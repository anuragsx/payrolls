require File.dirname(__FILE__) + '/../test_helper'

class SimpleIncomeTaxCalculatorTest < ActiveSupport::TestCase
  
  def test_calculate_for_employee_tds
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:simple_income_tax_calculator, :company => @company)
    Factory(:employee_tax, :employee => @employee,
            :company => @company,:created_at => @run_date - 1, :amount => 500)
    Factory(:employee_package, :employee => @employee, :company => @company, :basic => 10000, :start_date => @employee.commencement_date)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company )
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(slip.gross, 10000.0)
    assert_equal(slip.net, 9500.0)
    assert_equal(slip.deduction, -500.0)
    assert_equal(500.0, slip.billed_charge_for(SalaryHead.code_for_tds).abs)
  end

  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009))
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:simple_income_tax_company_calculator, :company => @company, :position => 2 )
  end

end
