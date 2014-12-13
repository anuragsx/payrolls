class EmployeeTdsReturn < ActiveRecord::Base

  belongs_to :company
  belongs_to :tds_return
  belongs_to :employee
  validates :employee_id, :company_id, :presence => true
  attr_accessor :is_included, :start_date, :end_date, :tds_deposited

  def start_date
    @start_date || tds_return.start_date
  end

  def end_date
    @end_date || tds_return.end_date
  end

  def tds_deposited
    @tds_deposited ||= employee.salary_slip_charges.under_head(SalaryHead.code_for_TDS).between_date(start_date,end_date).sum(:amount).abs
  end
  
  def is_included
    @is_included ||= (tds_deposited > 0)
  end

end
