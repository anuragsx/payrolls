class EmployeePackage < ActiveRecord::Base
  attr_accessible :start_date
  END_DATE = Date.end_of_time
  belongs_to :employee
  belongs_to :company
  has_many :employee_package_heads
  has_many :salary_slip_charges, :as => :reference
  belongs_to :company_grade
  accepts_nested_attributes_for :employee_package_heads, :allow_destroy => true
  
  validates :basic, :start_date, :company, :presence => true
  validates :basic, :numericality => {:only_integer => true, :greater_than => 0}

  attr_accessor :promoting,:suspending, :resuming

  before_create :set_end_date
  after_save :send_promote_event, :if => proc{|c|!!c.promoting}
  after_save :send_suspension_event, :if => proc{|c| !!c.suspending}
  after_save :send_resume_event, :if => proc{|c| !!c.resuming}
  after_create :update_end_date, :check_active
  before_validation :remove_blank_package_heads
  before_save :set_designation

  scope :last_first, :order => 'end_date desc'

  def gross
    basic
  end

  def active?
    end_date.end_of_time?
  end

  def ended?
    !active?
  end

  def period
    "#{start_date.to_s(:short_month_and_year)} - #{end_date.to_s(:short_month_and_year) if ended?}"
  end

  def total_income_packages_for_month(run_date)
    company.calculators.collect{|c| c.calculate_income(company, employee, self, run_date.end_of_financial_year)}.reject(&:blank?)
  end

  def total_income_for_month(run_date)
    amount = basic
    amount += total_income_packages_for_month(run_date).sum{|c| c.values.sum {|a| a[:amount]}}
    amount
  end
  
  def total_exemption_for_month(run_date)
    total_income_packages_for_month(run_date).sum{|c| c.values.sum {|a| a[:exempt_amount]}}
  end

  def ctc
    (total_for_month || 0) * 12
  end

  def total_for_month
    amount = basic
    amount += additional_package_for_month.sum{|c| c.values.sum}
    amount
  end

  def additional_package_for_month
    #Returns a Hash containing {salary_head_name => salary_head_amount}
    company.calculators.collect{|c| c.calculate_package_ctc(company,employee,self)}.reject(&:blank?)
  end

  def applicable_for_month?(month_start_date,month_end_date)
    if active?
      month_end_date >= self.start_date
    else
      (self.end_date >= month_start_date) && ( self.start_date <= month_end_date)
    end
  end

  def can_delete?
    employee.employee_packages.last_first.size > 1
  end

  private

  def check_active
    #TODO To be changed 
    self.employee.update_attribute(:status,'active') if self.employee
  end
  
  def set_end_date
    self.end_date ||= END_DATE
  end

  def lookup_amount_for(code)
    company.package_calculator.lookup_amount_for(code)
  end

  def send_promote_event
    company.calculators.each{|c|c.promote_employee!(self)}
  end

  def send_suspension_event
    company.calculators.each{|c|c.suspend_employee!(self)}
  end

  def send_resume_event
    company.calculators.each{|c|c.resume_employee!(self)}
  end
  
  def update_end_date
    l = employee.employee_packages.length
    l = 0 if l == 1 # Hash employee.employee_packages[1-2] return 0th index element
    emp = employee.employee_packages[l-2]    
    emp.update_attributes(:end_date => self.start_date) if emp && emp.active?
  end

  def view(company)
    charges = []
    if company.has_calculator?(FlexibleAllowanceCalculator)
      
    elsif company.has_calculator?(SimpleAllowanceCalculator)
      employee_package_heads.each do |eph|
        charges << {eph.salary_head.name => eph.amount}
      end
    end
  end

  def check_date
    self.start_date < self.end_date
  end

  def remove_blank_package_heads
    employee_package_heads.delete_if do |f|
      f.amount.blank?
    end
  end

  def set_designation    
    self.designation = 'Employee' if designation.blank?
  end
end