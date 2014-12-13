require File.dirname(__FILE__) + '/../test_helper'

class LeaveAccountingCalculatorTest < ActiveSupport::TestCase
  
  def test_leave_ratio_when_consume_next_year_last_year_nil
    setup_leave
    Factory(:basic_company_calculator, :company => @company, :position =>  2 )
    Factory(:company_leave, :company => @company, :leave_accrual => CompanyLeave::EARN_NOW_CONSUME_NEXT_YEAR)
    Factory(:employee_leave, :present => 20, :absent => 5, :salary_slip =>  nil, :salary_sheet => nil,
            :employee => @employee, :company => @company, :created_at => @run_date - 5)
    Factory(:employee_leave_balance, :employee => @employee, :company => @company,
            :financial_year => @run_date)
    Factory(:employee_leave_balance, :employee => @employee, :company => @company,
            :current_balance => 0, :earned_leaves => 0, :spent_leaves => 0,
            :opening_balance => 0,:financial_year => @run_date - 1.year)# Last years earning
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    assert_kind_of(Array, charges)
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_not_nil(slip.salary_slip_charges)
    assert_equal(1, slip.salary_slip_charges.count)
    charge = slip.salary_slip_charges.first
    assert_not_nil charge.amount
    assert_equal(8387.1, charge.amount)
    assert charge.amount > 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
  end

  def test_leave_ratio_when_consume_next_year_has_last_year_balance
    setup_leave
    Factory(:basic_company_calculator, :company => @company, :position =>  2 )
    Factory(:company_leave, :company => @company, :leave_accrual => CompanyLeave::EARN_NOW_CONSUME_NEXT_YEAR)
    EmployeeLeaveBalance.find_by_financial_year((@run_date - 1).year).update_attributes(
                                              :current_balance => 3)
    Factory(:employee_leave, :present => 20, :absent => 5, :salary_slip =>  nil, :salary_sheet => nil,
            :employee => @employee, :company => @company, :created_at => @run_date - 5)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    assert_kind_of(Array, charges)
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_not_nil(slip.salary_slip_charges)
    assert_equal(1, slip.salary_slip_charges.count)
    charge = slip.salary_slip_charges.first
    assert_not_nil charge.amount
    assert_equal(9354.8, charge.amount)
    assert charge.amount > 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
  end

  def test_leave_ratio_when_as_u_go_last_year_nil
    setup_leave
    Factory(:basic_company_calculator, :company => @company, :position =>  2 )
    Factory(:company_leave, :company => @company, :leave_accrual => CompanyLeave::AS_YOU_GO)
    Factory(:employee_leave, :present => 20, :absent => 5, :salary_slip =>  nil, :salary_sheet => nil,
            :employee => @employee, :company => @company, :created_at => @run_date - 5)
    Factory(:employee_leave_balance, :employee => @employee, :company => @company,
            :financial_year => @run_date)
    Factory(:employee_leave_balance, :employee => @employee, :company => @company,
            :current_balance => 0, :earned_leaves => 0, :spent_leaves => 0,
            :opening_balance => 0,:financial_year => @run_date - 1.year)# Last years earning
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    assert_kind_of(Array, charges)
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_not_nil(slip.salary_slip_charges)
    assert_equal(1, slip.salary_slip_charges.count)
    charge = slip.salary_slip_charges.first
    assert_not_nil charge.amount
    assert_equal(8709.7, charge.amount)
    assert charge.amount > 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
  end

  def test_leave_ratio_when_as_u_go_has_last_year_balance
    setup_leave
    Factory(:basic_company_calculator, :company => @company, :position =>  2 )
    Factory(:company_leave, :company => @company, :leave_accrual => CompanyLeave::AS_YOU_GO)
    Factory(:employee_leave, :present => 20, :absent => 5, :salary_slip =>  nil, :salary_sheet => nil,
            :employee => @employee, :company => @company, :created_at => @run_date - 5)
    Factory(:employee_leave_balance, :employee => @employee, :company => @company,
            :financial_year => @run_date)
    Factory(:employee_leave_balance, :employee => @employee, :company => @company,
            :current_balance => 3, :earned_leaves => 3, :spent_leaves => 0,
            :opening_balance => 0,:financial_year => @run_date - 1.year)# Last years earning
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    assert_kind_of(Array, charges)
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_not_nil(slip.salary_slip_charges)
    assert_equal(1, slip.salary_slip_charges.count)
    charge = slip.salary_slip_charges.first
    assert_not_nil charge.amount
    assert_equal(8709.7, charge.amount)
    assert charge.amount > 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
  end

  private

  def setup_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009))
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @emp_p = Factory(:employee_package, :employee => @employee, :company => @company,
            :basic => 10000, :start_date => @employee.commencement_date)
    Factory(:leave_accounting_company_calculator, :company => @company, :position =>  1)
  end

end
