class SalarySheet < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  include AASM
  aasm_column(:status)

  aasm_initial_state :initial

  aasm_state :finalized
  aasm_state :initial, :enter => :unfinalize!
  aasm_state :error

  aasm_event :do_finalize do
    transitions :to => :finalized, :from => [:initial]
  end

  aasm_event :do_unfinalize do
    transitions :to => :initial, :from => [:finalized]
  end

  aasm_event :do_error do
    transitions :to => :error, :from => [:initial]
  end

  belongs_to :company
  has_many :salary_slips, :dependent => :destroy
  has_many :salary_slip_charges, :dependent => :destroy
  has_many :salary_slips_with_includes, :class_name => 'SalarySlip', :include => [:salary_slip_charges => :salary_head]

  before_save :set_run_date, :set_financial_year

  before_destroy :unfinalize!
  validates :run_date, :company, :presence => true

  #scope :salary_sheet_for,lambda{|date| {:conditions => {:run_date => date.at_end_of_month}}}
  #scope :for_company,lambda{|c| {:conditions => {:company_id => c}}}
  #scope :in_fy, lambda{|fy| {:conditions => {:financial_year => fy}}}
  #scope :for_month, lambda{|d|{:conditions => ["month(run_date) = ? and year(run_date) = ?",d.month,d.year]}}
  #scope :after_date, lambda{|d|{:conditions => ["run_date > ?",d]}}
  #scope :between_date, lambda{|s_date,e_date|{:conditions => ["run_date >= ? &&  run_date <= ?",s_date,e_date]}}


  scope :salary_sheet_for, lambda{|date| where(:run_date => date.at_end_of_month)}
  scope :for_company, lambda{|c| where(:company_id => c)}
  scope :in_fy, lambda{|fy| where(:financial_year => fy)}
  scope :for_month, lambda{|d| where("month(run_date) = ? and year(run_date) = ?",d.month,d.year)}
  scope :after_date, lambda{|date| where("run_date > ?",d)}
  scope :between_date, lambda{|s_date,e_date| where("run_date >= ? &&  run_date <= ?",s_date,e_date)}


  #validate :check_total_days
  #validates_associated :salary_slips
  #before_validation  :generate_salary_slips

  attr_accessor :sheet_charges
  #TODO need to check
  #has_attached_file :doc

  def sheet_charges=(charge)
    @sheet_charges ||= {}
    return if charge.blank?
    charge.reject{|b|b.blank?}.each do |c|
      unless c.blank?
        @sheet_charges[c.salary_head] ||= []
        @sheet_charges[c.salary_head] << c
      end
    end
  end

  def after_create
    self.send_later(:background_operation)
  end

  def to_param
    run_date.to_s(:for_param)
  end

  def sheet_charges
    @sheet_charges || {}
  end

  def formatted_run_date
    "#{Time::RFC2822_MONTH_NAME[run_date.month-1]} #{run_date.year}"
  end

  def total_days_in_month
    Time.days_in_month(self[:run_date].month,self[:run_date].year)
  end
  #memoize :total_days_in_month

  def working_days=(days)
    self[:working_days] = days
    #self[:holidays] = total_days_in_month - days
  end

  def holidays=(holidays)
    self[:holidays] ||= holidays
  end

  def eligible_employees
    company.employees.select do |e|
      e.commencement_date <= run_date.at_end_of_month &&
        e.effective_package(run_date)
    end
  end

  def unfinalize!
    # Mark all Slip Charge with salary sheet
    salary_slips.each do |slip|
      transaction do
        slip.unfinalize!
      end
    end
  end

  def finalize!
    # Mark all Slip Charge with salary sheet
    salary_slips.each do |slip|
      transaction do
        slip.finalize!
      end
    end
  end

  def self.next_run_date
    last_sheet = find(:first,:order=>'run_date desc',:limit=>1)
    !!last_sheet ? last_sheet.run_date.next_month : Date.today.end_of_month
  end

  def is_finalized?
    status == "finalized"
  end

  def charges_under_head(head)
    salary_slip_charges.under_head(head)
  end

  def billed_charge_for(*heads)
    salary_slip_charges.select{|s|[*heads].include?(s.salary_head)}.sum{|x|x.amount}
  end

  def validate_on_create
    unless self.run_date.blank?
      unless SalarySheet.for_company(self.company).salary_sheet_for(self.run_date).blank?
        errors.add_to_base("Salary Sheet for #{self.formatted_run_date} exists already")
      end
    end
    unless self.company.blank?
      begin
        self.company.try(:calculators).each do |calculator|
          calculator.company = self.company
          calculator.is_ready? # Raise error
        end
    rescue Exception => e
      errors.add_to_base(e.message)
        return false
      end
    end
  end

  def slips_group_by_department
    salary_slips.group_by{|d| d.employee.department}
  end

  def total_contribution(head,field = :amount)
    salary_slip_charges.under_head(head).sum(field).try(:round,2) || 0
  end

  def slips_containing_head(code)
    salary_slips.select do |slip|
      !slip.salary_slip_charges.under_head(code).empty?
    end.group_by{|d| d.employee.department}
  end

  def total_employees_for_head(head)
    salary_slip_charges.under_head(head).count('distinct(employee_id)')
  end

  def package_calculator
    c = company.package_calculator
    c.salary_sheet = self
    c
  end

  def allowance_calculators
    company.allowance_calculators.uniq.each{|c|c.salary_sheet = self}
  end

  def deduction_calculators
    company.deduction_calculators.uniq.each{|c|c.salary_sheet = self}
  end

  def subtotals
    company.subtotal_calculators.uniq.each{|c|c.salary_sheet = self}
  end

  def grand_total
    salary_slips.sum(:net)
  end

  def background_operation
    begin
      generate_salary_slips
      generate_sheet_charges
      do_finalize!
      generated_and_attached_pdf
      send_sms_to_owner
      AdminMailer.send_later(:deliver_salary_sheet_information_to_admin,self) if Rails.env.production?
    rescue Exception => e
      begin self.do_error! rescue nil end
      logger.error("Exception #{e.message}")
      ExceptionMailer.deliver_exception_notification(e, {:company => self.company}) if Rails.env.production?
    end
  end

  def send_sms_by_delayed_job
    salary_slips.each do |s|
      if !s.employee.address.blank? && !s.employee.address.mobile_number.blank?
        SmsNotifier.send_salary_sms(s,s.employee.address.mobile_number)
      end
    end
  end

  private

  def generate_salary_slips
    self.eligible_employees.each do |emp|
      self.salary_slips.create!(:employee => emp, :company => company, :run_date => run_date)
    end
  end

  def generate_sheet_charges
    self.sheet_charges = package_calculator.calculate_for_sheet
    # Find applicable AllowanceCalculator
    (allowance_calculators + deduction_calculators + subtotals).each do |calc|
      self.sheet_charges = calc.calculate_for_sheet
    end
    round = company.round
    sheet_charges.values.flatten.each do |shc|
      shc.salary_sheet = self
      shc.company = company
      shc.amount = shc.amount.round(round)
      shc.charge_date = run_date
      shc.save!
    end
  end

  def check_total_days
    # ensure that the total working_days + holidays in the company are not more than the
    # number of days in the month
    #if total_days_in_month != self.working_days + (self.try(:holidays) || 0)
    #  errors.add(:working_days,"The number of days in the Salary Sheet Month #{total_days_in_month} does not equal the holidays plus working days")
    # => end
    true
  end

  def set_run_date
    self.run_date = self.run_date.end_of_month
  end

  def set_financial_year
    self.financial_year = self.run_date.financial_year
  end

  def generated_and_attached_pdf
    SalaryProcess.send_later(:salary_sheet_generator,self)if self && self.is_finalized?
  end

  def send_sms_to_owner    
    if self && self.is_finalized? && company.owner && company.owner.address.try(:mobile_number) && Rails.env.production? && SMS_ENABLED
      SmsNotifier.send_total_salary_sms(self,company.owner.address.try(:mobile_number))
    end
  end

end
