require File.dirname(__FILE__) + '/../test_helper'

class BonusCalculatorTest < ActiveSupport::TestCase
  
  def test_calculate_basic_is_basic_threshold
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:bonus_company_calculator, :company => @company)
    Factory(:employee_package, :employee => @employee, :company => @company,
            :basic => 10000, :start_date => @employee.commencement_date)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(slip.gross, 10000.0)
    assert_equal(slip.net, 10000.0)
    assert_equal(slip.deduction, 0)
    assert_equal(3500.0, sheet.billed_charge_for(SalaryHead.code_for_bonus).abs)
  end

  def test_calculate_higher_basic_then_basic_threshold
    setup_simple_leave
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:bonus_company_calculator, :company => @company)
    Factory(:employee_package, :employee => @employee, :company => @company, :basic => 20000, :start_date => @employee.commencement_date)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(1, charges.length)
    assert_equal(slip.gross, 20000.0)
    assert_equal(slip.net, 20000.0)
    assert_equal(slip.deduction, 0)
    assert_equal(0.0, sheet.billed_charge_for(SalaryHead.code_for_bonus).abs)
  end

  def test_calculate_within_bonus_threshold
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:bonus_company_calculator, :company => @company)
    Factory(:employee_package, :employee => @employee, :company => @company, :basic => 3499, :start_date => @employee.commencement_date)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(slip.gross, 3499.0)
    assert_equal(slip.net, 3499.0)
    assert_equal(slip.deduction, 0)
    assert_equal(3499, sheet.billed_charge_for(SalaryHead.code_for_bonus).abs)
  end

  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009)) # Tested for july 31 days
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    Factory(:simple_leave_company_calculator, :company => @company, :position =>  1)
  end

end
