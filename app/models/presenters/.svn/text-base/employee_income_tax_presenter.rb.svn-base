class EmployeeIncomeTaxPresenter
  extend ActiveSupport::Memoizable
  include ActionView::Helpers::NumberHelper
    
  def initialize(company,employee,start_date,end_date)
    @@employee_tds_head ||= SalaryHead.code_for_tds
    @company = company
    @employee = employee
    @start_date = start_date
    @end_date = end_date
    @fy_year = start_date.year
  end

  def pan
    EmployeeTaxDetail.for_employee(@employee).last.try(:pan)
  end
  
  def reference_no
    @employee.identification_number
  end

  def name
    @employee.name
  end
  
  def taxable_amount
    salary_heads.sum{|s|s.amount}.abs  - salary_heads.sum{|s|s.exempt_amount}.abs
  end
  
  def tax_on_income
    deducted_tax.to_f- edu_cess.to_f
  end

  def surcharge
    0.0
  end
  
  def deducted_tax
    SalarySlipCharge.under_head(@@employee_tds_head).between_date(@start_date,@end_date).for_employee(@employee).sum(:amount).abs ||0.0
  end
  memoize :deducted_tax
  
  def edu_cess
    number_with_precision((deducted_tax * (EDUCATION_CESS/ (1 + EDUCATION_CESS))).round, :precision => 1) ||0.0
  end
  memoize :edu_cess

  private
  
  def salary_heads
    [@employee.salary_slip_charges.in_fy(@fy_year).between_date(@start_date,@end_date).all(:conditions => "amount > 0") +
        ["charges_for_employee_pf","charges_for_employee_vpf","charges_for_insurance"].map do |charge|
        SalaryHead.send(charge).between_date(@start_date,@end_date).for_employee(@employee)
      end].flatten
  end
  memoize :salary_heads
  
end
