require File.dirname(__FILE__) + '/../test_helper'

class CompanyLeaveTest < ActiveSupport::TestCase

  should_belong_to :company
  should_validate_presence_of :company_id, :month_day_calculation, :leave_accrual, :rate_of_leave
  should_validate_numericality_of :month_day_calculation, :leave_accrual, :rate_of_leave, :month_length

  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]

  def test_month_days
    setup_company_leave
    salary_sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)   
    assert_equal(31, @company_leave.month_days(salary_sheet))
  end

  def test_default_length
    setup_company_leave
    assert_equal(31, @company_leave.default_length(@run_date))
  end

  def test_month_length_desc
    setup_company_leave   
    assert_equal(["Input will be given with Salary Sheet", 1], @company_leave.month_length_desc)
  end  

  def test_plan_change_settlement
    c = Factory(:company)
   @leave = Factory(:company_leave, :company => c)
   e = Factory(:employee, :company => c)
   Factory(:employee_package, :employee => e)
  end

  def test_carry_forward_leave_balances
     c = Factory(:company)
     @leave = Factory(:company_leave, :company => c)
     e1 = Factory(:employee, :company => c)
     e2 = Factory(:employee, :company => c)
  end
  
  private

  def setup_company_leave
    @company = Factory(:company)
    @run_date = Date.parse("31 oct 2009")
    @company_leave = Factory(:company_leave, :company => @company)
  end
end
