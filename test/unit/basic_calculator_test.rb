require File.dirname(__FILE__) + '/../test_helper'

class BasicCalculatorTest < ActiveSupport::TestCase


  def test_calulate_with_as_u_go_have_last_year_balance
    setup_for_complex_leave
    Factory(:company_leave, :company => @company, :leave_accrual => CompanyLeave::EARN_NOW_CONSUME_NEXT_YEAR)
    EmployeeLeaveBalance.find_by_financial_year((@run_date - 1).year).update_attributes(
                                              :current_balance => 3)
                                              
    Factory(:employee_leave, :absent => 4, :salary_slip => nil, :salary_sheet => nil, :present => 20,
      :employee => @employee, :company => @company, :created_at => @run_date - 1)
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
    assert_equal(9677.4, charge.amount)
    assert charge.amount > 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
  end

  def test_calulate_with_as_u_go_last_year_balance_nil
    setup_for_complex_leave
    Factory(:company_leave, :company => @company, :leave_accrual => CompanyLeave::AS_YOU_GO, :rate_of_leave => 12)
    Factory(:employee_leave, :absent => 4, :salary_slip => nil, :salary_sheet => nil, :present => 20,
      :employee => @employee, :company => @company, :created_at => @run_date - 1)
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
    assert_equal(9248.4, charge.amount)
    assert charge.amount > 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
  end


  def test_calculate_with_simple_leave
   setup_simple_leave
    Factory(:employee_leave, :absent => 2, :salary_slip => nil, :salary_sheet => nil,
            :employee => @employee, :company => @company,  :created_at => @run_date - 1.day )
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

  def test_calculate_with_simple_leave_for_zero_net
    setup_simple_leave
    Factory(:employee_leave, :absent => 31, :salary_slip => nil, :salary_sheet => nil,
            :employee => @employee, :company => @company, :created_at => @run_date - 1.day )
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    assert_not_nil(slip.salary_slip_charges)
    assert_equal(1, slip.salary_slip_charges.count)
    charge = slip.salary_slip_charges.first
    assert_not_nil charge.amount
    assert_equal(0, charge.amount)
    assert charge.amount == 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
  end

  def test_calulate_with_consume_last_year_balance_nil
    setup_for_complex_leave
    Factory(:company_leave, :company => @company, :leave_accrual => CompanyLeave::EARN_NOW_CONSUME_NEXT_YEAR )
    Factory(:employee_leave_balance, :employee => @employee, :company => @company,
            :financial_year => @run_date)
    Factory(:employee_leave_balance, :employee => @employee, :company => @company,
            :financial_year => @run_date - 1.year)
    Factory(:employee_leave, :absent => 3, :salary_slip => nil, :salary_sheet => nil, :present => 20,
      :employee => @employee, :company => @company, :created_at => @run_date - 1)
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
    assert_equal(9032.3, charge.amount)
    assert charge.amount > 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
  end

    def test_calulate_with_consume_and_have_last_year_balance
    setup_for_complex_leave
    Factory(:company_leave, :company => @company, :leave_accrual => CompanyLeave::EARN_NOW_CONSUME_NEXT_YEAR )
    EmployeeLeaveBalance.find_by_financial_year((@run_date - 1).year).update_attributes(
                                              :current_balance => 4)
    Factory(:employee_leave, :absent => 3, :salary_slip => nil, :salary_sheet => nil, :present => 20,
      :employee => @employee, :company => @company, :created_at => @run_date - 1)
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
    assert_equal(10000.0, charge.amount)
    assert charge.amount > 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
  end

  private
  
  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009)) # Tested for july 31 days
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    @cc = Factory(:basic_company_calculator, :company => @company, :position =>  2 )
    Factory(:employee_package, :employee => @employee, :company => @company, :basic => 10000,
            :start_date => @employee.commencement_date)
  end

  def setup_for_complex_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009))
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @leave_calculator = Factory(:leave_accounting_company_calculator, :company => @company, :position =>  1 )
    @cc = Factory(:basic_company_calculator, :company => @company, :position =>  2 )
    Factory(:employee_package, :employee => @employee, :company => @company, :basic => 10000,
            :start_date => @employee.commencement_date)
  end
  
end