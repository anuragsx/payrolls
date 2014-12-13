require File.dirname(__FILE__) + '/../test_helper'

class DearnessReliefCalculatorTest < ActiveSupport::TestCase

  def test_calculate_if_have_only_basic
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    @drcc = Factory(:dearness_relief_company_calculator, :company => @company, :position =>  3 )
    Factory(:company_loading, :company => @company, :loading_percent => 2, :created_at => @run_date - 1.day)
    Factory(:employee_leave, :absent => 0, :salary_slip => nil, :salary_sheet => nil,
      :employee => @employee, :company => @company)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(slip.gross, 10200.0)
    assert_equal(slip.net, 10200.0)
    assert_equal(slip.deduction, 0.0)
  end

  def test_calculate_if_have_only_basic_and_da
    setup_simple_leave
    da = SalaryHead.code_for_da
    @sacc = Factory(:simple_allowance_company_calculator,  :company => @company, :position =>  2)
    Factory(:company_allowance_head, :company => @company, :salary_head => da, :position => 1)
    Factory(:employee_package_head, :employee_package => @emp_p,
            :company => @company, :employee =>  @employee, :amount => 200, :salary_head => da)
    @drcc = Factory(:dearness_relief_company_calculator, :company => @company, :position =>  4)
    Factory(:company_loading, :company => @company, :loading_percent => 3, :created_at => @run_date - 1.day)
    Factory(:employee_leave, :absent => 0, :salary_slip => nil, :salary_sheet => nil,
            :employee => @employee, :company => @company)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(3, charges.length)
    assert_equal(slip.gross, 10506.0) # 10000 + 200 + (10200 * 3) = 10506
    assert_equal(slip.net, 10506.0)
    assert_equal(slip.deduction, 0.0)
  end

  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009)) # Tested for july 31 days
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @emp_p = Factory(:employee_package, :employee => @employee, :company => @company,
            :basic => 10000, :start_date => @employee.commencement_date)
    Factory(:simple_leave_company_calculator, :company => @company, :position =>  1)
  end
end
