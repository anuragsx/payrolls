require File.dirname(__FILE__) + '/../test_helper'

class ExpenseClaimCalculatorTest < ActiveSupport::TestCase
  
  def test_calculate
    
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:employee_package, :employee => @employee, :company => @company, :basic => 10000, :start_date => @employee.commencement_date)
    Factory(:expense_claim_company_calculator, :company => @company)
    Factory(:expense_claim, :company => @company, :employee => @employee, :salary_slip => nil,
           :amount => 2000, :expensed_at => @run_date - 7)
    
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(12000.0, slip.gross)
    assert_equal(12000.0, slip.net)
    assert_equal(slip.deduction.abs, 0.0)
    assert_equal(2000.0, slip.billed_charge_for(SalaryHead.code_for_expense).abs)
  end
  
  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009)) # Tested for july 31 days
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
  end

end