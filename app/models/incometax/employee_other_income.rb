class EmployeeOtherIncome < ActiveRecord::Base
  
  validates_presence_of :employee_id, :company_id,:amount,:created_at

  validates :amount, :greater_than => 0, :numericality => { :only_integer => true }
  validates :already_tax_paid_on_other_income, :greater_than_or_equal_to => 0, :numericality => { :only_integer => true }

  belongs_to :employee
  belongs_to :company

  has_many :salary_slip_charges, :as => :reference

  scope :unbilled, :conditions => "salary_slip_id is null"
  scope :billed, :conditions => "salary_slip_id is not null"
  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_slip, lambda{|s|{:conditions => ["salary_slip_id = ?",s]}}
  scope :for_financial_year, lambda{|fy|{:conditions => ["financial_year = ?",fy]}}

  before_save :set_financial_year
  before_destroy :check_charges
  
  def self.effective_other_income(employee,date)
    self.for_employee(employee).for_financial_year(date.financial_year)
  end

  def self.total_other_incomes(employee,date)
    effective_other_income(employee,date).sum('amount') || 0
  end
  
  def self.total_other_tax(employee,date)
    effective_other_income(employee,date).sum('already_tax_paid_on_other_income') || 0
  end
  
  def self.total_billed_other_incomes(employee,date)
    effective_other_income(employee,date).billed.sum('amount') || 0
  end

  def self.total_unbilled_other_incomes(employee,date)
    effective_other_income(employee,date).unbilled.sum('amount') || 0
  end

  def self.total_billed_tax(employee,date)
    effective_other_income(employee,date).billed.sum('already_tax_paid_on_other_income') || 0
  end

  def self.total_unbilled_tax(employee,date)
    effective_other_income(employee,date).unbilled.sum('already_tax_paid_on_other_income') || 0
  end
  
  def self.finalize_for_slip!(run_date,salary_slip, employee)
    unbilled.for_financial_year(run_date.financial_year).for_employee(employee).each {|d| d.update_attribute(:salary_slip_id,salary_slip.id)}
  end

  def self.unfinalize_for_slip!(salary_slip)
    update_all("salary_slip_id = null",["salary_slip_id = ?",salary_slip.id])
  end

  def is_billed?
    !!salary_slip_id
  end

  def created_at_before_type_cast
    (read_attribute(:created_at)).to_s(:date_month_and_year) if read_attribute(:created_at)
  end

  private
  
  def set_financial_year
    self.financial_year = created_at.to_date.financial_year
  end

  def check_charges
    !is_billed?
  end
end
