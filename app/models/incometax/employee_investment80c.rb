class EmployeeInvestment80c < ActiveRecord::Base
  THRESHOLD = 100000
  validates :employee_id, :company_id,:employee_investment_scheme_id,:amount,:created_at, :presence => true
  validates :amount, :greater_than => 0, :numericality => { :only_integer => true }

  belongs_to :employee
  belongs_to :employee_investment_scheme
  belongs_to :employee_tax_detail
  belongs_to :company


  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_financial_year, lambda{|fy|{:conditions => ["financial_year = ?",fy]}}
  scope :upto_date_within_fy, lambda{|y,date|{:conditions => ["financial_year = ? && created_at <= ?",y,date]}}
  scope :between_date, lambda{|s_date,e_date|{:conditions => ["created_at >= ? &&  created_at <= ?",s_date,e_date]}}

  before_save :set_financial_year

  def self.effective_investments(employee,date)
    self.for_employee(employee).upto_date_within_fy(date.financial_year,date)
  end

  def self.salary_investments(employee, date)
    [SalaryHead.charges_for_employee_pf.upto_date_within_fy(date.financial_year, date).for_employee(employee) +
      SalaryHead.charges_for_employee_vpf.upto_date_within_fy(date.financial_year, date).for_employee(employee) +
      SalaryHead.charges_for_insurance.upto_date_within_fy(date.financial_year, date).for_employee(employee)].flatten
  end

  def self.total_investments(employee,date)
    effective_investments(employee,date).sum('amount') +
      self.salary_investments(employee, date).each{|a| a.amount = a.amount.abs}.sum(&:amount)
  end
  
  def self.eligible_amount_invested(amount)
    return [amount,THRESHOLD].min
  end
  
  def set_financial_year
    self.financial_year = created_at.to_date.financial_year
  end

  def created_at_before_type_cast
    (read_attribute(:created_at)).to_s(:date_month_and_year) if read_attribute(:created_at)
  end

end