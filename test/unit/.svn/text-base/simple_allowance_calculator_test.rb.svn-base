require File.dirname(__FILE__) + '/../test_helper'

class SimpleAllowanceCalculatorTest < ActiveSupport::TestCase

  def test_calculate_when_have_same_allowances_as_company_allowances
    setup_simple_leave
    hra = SalaryHead.code_for_rent
    emp_package = Factory(:employee_package, :employee => @employee,
      :company => @company, :basic => 10000, :start_date => @employee.commencement_date)
    Factory(:company_allowance_head, :company => @company, :salary_head => hra)
    Factory(:employee_package_head, :employee => @employee, :company => @company,
      :amount => 500, :salary_head => hra, :employee_package => emp_package)
    Factory(:employee_leave, :absent => 2, :salary_slip => nil, :salary_sheet => nil,
      :employee => @employee, :company => @company)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
  end

  def test_employee_package_cannot_have_allwance_which_are_not_in_company_allowances
    setup_simple_leave
    hra = SalaryHead.code_for_rent
    emp_package = Factory(:employee_package, :employee => @employee,
      :company => @company, :basic => 10000, :start_date => @employee.commencement_date)
    Factory(:company_allowance_head, :company => @company, :salary_head => Factory(:tvl))
    Factory(:employee_package_head, :employee => @employee, :company => @company,
      :amount => 500, :salary_head => hra, :employee_package => emp_package)
    Factory(:employee_leave, :absent => 2, :salary_slip => nil, :salary_sheet => nil,
      :employee => @employee, :company => @company)
    sheet = Factory(:salary_sheet, :run_date => @run_date , :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length) # Only basic charges gets generated
  end

  def test_employee_package_can_only_have_company_allowances
    setup_simple_leave
    hra = SalaryHead.code_for_rent
    tvl = SalaryHead.code_for_conveyance
    emp_package = Factory(:employee_package, :employee => @employee,
      :company => @company, :basic => 10000, :start_date => @employee.commencement_date)
    Factory(:company_allowance_head, :company => @company, :salary_head => tvl)
    Factory(:employee_package_head, :employee => @employee, :company => @company,
      :amount => 500, :salary_head => hra, :employee_package => emp_package)
    Factory(:employee_package_head, :employee => @employee, :company => @company,
      :amount => 1500, :salary_head => tvl, :employee_package => emp_package)
    Factory(:employee_leave, :absent => 2, :salary_slip => nil, :salary_sheet => nil,
      :employee => @employee, :company => @company)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(3, charges.length) # Only have TVL and basic allowance
  end

  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009)) # Tested for july 31 days
    @company = Factory(:company)
    Factory(:hra_company_allowance_head, :company => @company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    @cc = Factory(:simple_allowance_company_calculator, :company => @company, :position =>  2 )
  end

end
