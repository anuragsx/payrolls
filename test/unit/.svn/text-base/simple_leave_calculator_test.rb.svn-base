require File.dirname(__FILE__) + '/../test_helper'

class SimpleLeaveCalculatorTest < ActiveSupport::TestCase

  def test_leave_ratio
    setup_simple_leave
    Factory(:basic_company_calculator, :company => @company, :position =>  2 )
    Factory(:employee_package, :employee => @employee, :company => @company,
            :basic => 10000, :start_date => @employee.commencement_date)
    Factory(:employee_leave, :present => 29, :absent => 2, :salary_slip =>  nil, :salary_sheet => nil,
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
    assert charge.amount > 0
    assert_instance_of(Float, charge.amount)
    assert_equal("basic", charge.salary_head.code)
    assert_equal("Special", charge.salary_head.salary_head_type)
    assert_equal(9354.8, charge.amount)
  end

  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009)) # Tested for july 31 days
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    Factory(:simple_leave_company_calculator, :company => @company, :position =>  1)
  end

end