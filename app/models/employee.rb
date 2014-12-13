class Employee < ActiveRecord::Base
  attr_accessible :bank, :name, :commencement_date, :department_id, :identification_number,
                  :account_number, :bank_id, :address_attributes, :employee_detail_attributes, :email,
                  :care_of, :date_of_birth, :sex
  EMPLOYEE_STATUS = [['Active'], ['Resigned'],['Suspended']]
  #extend ActiveSupport::Memoizable
  require 'memoist'
  extend Memoist
  include AASM
  belongs_to :company
  belongs_to :department
  belongs_to :bank
  has_one :employee_detail, :dependent => :destroy
  accepts_nested_attributes_for :employee_detail, :allow_destroy => true
  has_many :employee_packages, :dependent => :destroy
  accepts_nested_attributes_for :employee_packages, :allow_destroy => true

  has_one :address,:as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address, :allow_destroy => true
  
  has_many :salary_slips, :dependent => :destroy
  has_many :salary_slip_charges
  has_many :referenced_charges, :class_name => 'SalarySlipCharge', :as => :reference
  after_create :send_create_event_to_calculators

  #TODO can check later.
  before_validation :set_status

  #validates_presence_of :name, :company_id, :commencement_date
  validates :name, :company_id, :commencement_date, :presence => true
  attr_accessor :resign_date,:earned_leaves , :current_balance

  scope :recent, lambda{|*limit|{:limit => (limit.first || 5), :order => "updated_at desc"}}
  
  aasm_initial_state :initial
  aasm_column :status
  aasm_state :initial
  aasm_state :active
  aasm_state :resigned
  aasm_state :suspended

  aasm_event :activate do
    transitions :from => [:initial,:suspended], :to => :active, :on_transition => :do_active!
  end

  aasm_event :resign do
    transitions :from => :active, :to => :resigned, :on_transition => :do_resign!
  end

  aasm_event :suspend do
    transitions :from => :active, :to => :suspended, :on_transition => :do_suspend!
  end

  def next_possible_events    
    aasm_events_for_state(status.to_sym)
  end

  def current_package
    employee_packages.last
  end
  memoize :current_package

  def end_date
    current_package.try(:end_date)
  end
 
  def current_basic
    current_package.basic
  end

  def effective_package(date)
    start_date = date.at_beginning_of_month
    end_date = date.end_of_month
    employee_packages.last_first.detect {|a| a.applicable_for_month?(start_date,end_date)}
  end

  def effective_basic(date)
    effective_package(date).try(:basic) || 0.0
  end

  def estimated_taxable_income_for_month(month)
    return 0 if month.nil?
    package = effective_package(month) ? effective_package(month) : current_package
    package.total_income_for_month(month) - package.total_exemption_for_month(month)
  end

  def estimated_for_month(month)
    return 0 if month.nil?
    package = effective_package(month) ? effective_package(month) : current_package
    package.total_income_packages_for_month(month)
  end

  def self.search(search)
    valid_opts = [:name_like_any, :status_is, :recent, 
      :department_id_equals, :order, :employee_packages_designation_like]
    search ||=  {:status_is => "active"}
    search = search.delete_if{|k,v| !valid_opts.include?(k.to_sym)}
    search[:name_like_any] = search[:name_like_any].try(:split," ")
    # To search from only Current Package for Active Employees
    search = search.merge({:employee_packages_end_date_equals => Date.end_of_time.to_s}) if search[:status_is] == "Active"
    searchlogic(search)
  end

  def department_name
    department.try(:name)
  end
  
  def employee_name
    name.try(:titleize)
  end

  def employee_pdf_password
    pdf_password || company.default_employee_pdf_password
  end
  
  def promote!(package_details)    
    new_package_details = package_details[:employee_package]
    begin
      transaction do       
        new_package_details[:start_date] ||= Date.today        
        new_package_details[:promoting] = true
        company.package_calculator.type.constantize.promote_package!(package_details,self)
      end
      true
    rescue StandardError => e     
      errors.add(:error,e.to_s)
      false
    end
  end

  def do_suspend!   
    @resign_date ||= Date.today
    attrs={}
    #Set current package date to a specified date on resignation or suspension
    ep = employee_packages.last
    attrs[:end_date] = @resign_date
    attrs.reverse_merge!(ep.attributes)
    attrs[:suspending] = true
    ep.update_attributes(attrs)    
  end

  def do_active!    
    @resign_date ||= Date.today
    attrs = {}
    attrs[:start_date] = @resign_date
    attrs[:end_date] = Date.end_of_time
    #fetch last active package
    ep = employee_packages.last
    #clone last package to new one
    attrs.reverse_merge!(ep.attributes) if ep
    attrs[:resuming] = true
    employee_packages.create!(attrs)   
  end

  def do_resign!
    @resign_date ||= Date.today
    attrs={}
    ep = employee_packages.last
    attrs[:end_date] = resign_date
    attrs.reverse_merge!(ep.attributes)
    attrs[:resuming] = false
    ep.update_attributes(attrs)
    if company.has_calculator?(LeaveAccountingCalculator)
      earning = EmployeeLeave.earned_leaves(self)
      earning.update_attribute(:earned_leaves,earned_leaves)
      earning.update_attribute(:current_balance,current_balance)
    end
  end

  def complete_address
    address.complete_address if address
  end

  def bank_name
    bank.try(:name)
  end
  
  def company_name
    company.try(:name)
  end

  def formatted_commencement_date
    commencement_date.try(:to_s,:date_month_and_year)
  end

  def designation
    current_package.try(:designation)
  end

  def current_package_id
    current_package.id
  end

  def sex
    (employee_detail.sex? ? "Male" : "Female") if employee_detail
  end
  
  def care_of
    employee_detail.try(:care_of)
  end

  private

  def send_create_event_to_calculators
    company.calculators.each{|c|c.employee_added!(self)}
  end

  def set_status
    employee_packages.blank? ? self.status = "initial" : self.status = "active"
  end

end