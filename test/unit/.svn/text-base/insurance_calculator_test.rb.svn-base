require File.dirname(__FILE__) + '/../test_helper'

class InsuranceCalculatorTest < ActiveSupport::TestCase

  def test_calculate
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:insurance_company_calculator, :company => @company)
    Factory(:employee_insurance_policy, :employee => @employee, :company => @company,
            :monthly_premium => 100, :expiry_date => @run_date + 365, :created_at => @run_date - 1.month)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(10000.0, slip.gross)
    assert_equal(9900.0, slip.net)
    assert_equal(slip.deduction.abs, 100)
    assert_equal(100.0, slip.billed_charge_for(SalaryHead.code_for_insurance).abs)
  end

  def test_calculate_when_lic_expired
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:insurance_company_calculator, :company => @company)
    Factory(:employee_insurance_policy, :employee => @employee, :company => @company,
            :monthly_premium => 100, :expiry_date => @run_date - 365, :created_at => @run_date - 1.month)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(1, charges.length)
    assert_equal(10000.0, slip.gross)
    assert_equal(10000.0, slip.net)
    assert_equal(slip.deduction.abs, 0)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_insurance).abs)
  end

  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009)) # Tested for july 31 days
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    Factory(:employee_package, :employee => @employee, :company => @company, :basic => 10000, :start_date => @employee.commencement_date)
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
  end

end
