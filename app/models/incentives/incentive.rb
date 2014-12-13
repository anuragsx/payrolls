class Incentive < ActiveRecord::Base
  
  belongs_to :employee
  belongs_to :company
  belongs_to :salary_slip
  has_many :salary_slip_charges, :as => :reference

  validates :employee_id, :company_id, :amount, :description, :incentive_at, :presence => true
  validates :amount, :greater_than => 0, :numericality => { :only_integer => true }
  before_destroy :not_billed

  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_company, lambda{|e|{:conditions => ["company_id = ?",e]}}
  scope :incentive_in, lambda{|e|{:conditions => ["month(incentive_at) = ? and year(incentive_at) = ?",e.month,e.year]}}
  scope :unbilled, :conditions => ["salary_slip_id is null"]
  scope :in_years, lambda{|yrs|{:conditions => ["year(incentive_at) in (?)",yrs]}}
  scope :in_months,lambda{|mnth|{:conditions => ["month(incentive_at) in (?)", mnth]}}

  def self.finalize_for_slip!(run_date,salary_slip,employee)
    for_employee(employee).incentive_in(run_date).unbilled.each {|d| d.update_attribute(:salary_slip_id,salary_slip.id)}
  end

  def self.unfinalize_for_slip!(salary_slip)
    update_all("salary_slip_id = null",["salary_slip_id = ?",salary_slip.id])
  end

  def self.employee_month_wise(employee)
    for_employee(employee).sum(:amount,:group => "date_format(incentive_at,'%b %Y')")
  end

  def self.company_employee_wise(company)
    for_company(company).sum(:amount,:group => "employee")
  end

  def self.employee_total(employee)
    for_employee(employee).sum(:amount)
  end

  def billed?
    !salary_slip_id.blank?
  end

  def not_billed
    !billed?
  end

  def self.create_multi(attributes,company,date=Date.today)
    errors = []
    attributes.reject{|a|a['amount'].blank? or a['amount'].to_i == 0}.each do |attr|
      transaction do
        e = self.new(attr)
        e.incentive_at = date
        e.company = company
        unless e.save
          errors << e.errors.to_a
        end
      end
    end
    errors.uniq
  end

  def self.search(company,year=Date.today.year,employee=nil)
    result = for_company(company)
    result = result.for_employee(employee) unless employee.blank?
    result = result.select{|x|x.incentive_at.financial_year == year}
    result.group_by{|ex| ex.incentive_at.month}
  end

  def self.detail_search(company,params,date)
    scope = for_company(company)
    scope = scope.scoped_by_employee_id(params[:employee]) unless params[:employee].blank?
    incentives = scope.incentive_in(date)
    incentives
  end
end
