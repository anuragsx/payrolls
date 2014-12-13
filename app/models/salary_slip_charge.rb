class SalarySlipCharge < ActiveRecord::Base

  belongs_to :employee
  belongs_to :salary_slip
  belongs_to :salary_sheet
  belongs_to :company
  belongs_to :salary_head
  belongs_to :reference, :polymorphic => true

  validates :amount, :salary_head_id, :charge_date, :presence => true

  before_create :default_financial_year

  scope :positionally, :order => "salary_head_id"
  scope :billed, :conditions => "salary_sheet_id is not null"
  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}
  scope :under_head, lambda{|h|{:conditions => ["salary_head_id = ?",h]}}
  scope :on_salary_slip, lambda{|s|{:conditions => ["salary_slip_id = ?",s]}}
  scope :on_salary_sheet, lambda{|s|{:conditions => ["salary_sheet_id = ?",s]}}
  scope :for_reference, lambda{|r|{:conditions => ["reference_type = ? and reference_id = ?",r.class.name,r]}}
  scope :after_date, lambda{|d|{:conditions => ["charge_date > ?",d]}}
  scope :in_fy, lambda{|d|{:conditions => ["financial_year = ?",d]}}
  scope :for_month, lambda{|d| {:conditions => ["month(charge_date) = ? and year(charge_date) = ?",d.month,d.year]}}
  scope :upto_date_within_fy, lambda{|y,date|{:conditions => ["salary_sheets.financial_year = ? && salary_sheets.run_date <= ?",y,date],:include => :salary_sheet}}
  scope :between_date, lambda{|s_date,e_date|{:conditions => ["charge_date >= ? &&  charge_date <= ?",s_date,e_date]}}


  def exempt_amount
    (amount.abs - (taxable_amount || 0).abs || 0).round(1)
  end

  private
  
  def default_financial_year
    self.financial_year ||= charge_date.financial_year
  end

end
