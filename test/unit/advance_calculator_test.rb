require File.dirname(__FILE__) + '/../test_helper'

class AdvanceCalculatorTest < ActiveSupport::TestCase
  
  def test_calculate
    setup_simple_leave
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:employee_advance_company_calculator, :company => @company)
    Factory(:employee_advance, :employee => @employee, :company => @company,
            :amount => 5000, :salary_slip => nil, :created_at => @run_date - 10)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(slip.gross, 10000.0)
    assert_equal(slip.net, 5000.0)
    assert_equal(slip.deduction.abs, 5000.0)
    assert_equal(5000.0, slip.billed_charge_for(SalaryHead.code_for_advance).abs)
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
