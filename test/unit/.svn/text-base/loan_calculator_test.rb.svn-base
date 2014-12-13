require File.dirname(__FILE__) + '/../test_helper'

class LoanCalculatorTest < ActiveSupport::TestCase

  def test_calculate_when_emi_override_is_higher_than_emi
    run_date = Date.new(2009, 7, Time.days_in_month(7,2009))
    setup_simple_leave
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:employee_loan_company_calculator, :company => @company)
    emp_loan = Factory(:employee_loan, :employee => @employee, :company => @company,
                       :loan_amount => 1200, :created_at => @run_date - 12.months)
    Factory(:effective_loan_emi, :employee => @employee, :employee_loan => emp_loan,
            :amount => 100, :created_at => @run_date - 12.months)
    (1..11).to_a.reverse.each  do |i|
      @company.calculators.each{|c|c.unmemoize_all if c.respond_to?('unmemoize_all')}
      sheet = Factory(:salary_sheet, :run_date => run_date - i.month, :company => @company)
      sheet.finalize!
    end
    Factory(:effective_loan_emi, :employee_loan => emp_loan, :employee =>  @employee,
            :amount => 150, :created_at => run_date)
    @company.calculators.each{|c|c.unmemoize_all if c.respond_to?('unmemoize_all')}
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
    assert_equal(100.0, slip.billed_charge_for(SalaryHead.code_for_loan).abs)
  end

  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009))
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @emp_p = Factory(:employee_package, :employee => @employee, :company => @company, :basic => 10000, :start_date => @employee.commencement_date)
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
  end

end
