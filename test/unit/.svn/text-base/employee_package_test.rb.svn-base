require File.dirname(__FILE__) + '/../test_helper'

class EmployeePackageTest < ActiveSupport::TestCase
  should_belong_to :employee
  should_belong_to :company
  should_have_many :employee_package_heads
  should_have_many :salary_slip_charges

  #should_validate_presence_of :name, :package
  should_validate_numericality_of :basic

  def test_gross
    setup
    assert_equal(10000.0,@emp_package.gross)
  end

  def test_active
    setup
    assert @emp_package.active?
  end  

  def test_ctc_when_do_not_have_package_calculator
    setup
    assert_equal @emp_package.basic*12, @emp_package.ctc
  end

  def test_ctc_when_we_have_simple_basic_calculator
    setup
    Factory(:basic_company_calculator, :company => @company)
    assert_equal({}, @emp_package.additional_package_for_month)
    assert_equal @emp_package.basic*12, @emp_package.ctc
  end

  def test_ctc_when_we_have_simple_allowance_calculator_and_not_have_allowances
    setup
    Factory(:simple_allowance_company_calculator, :company => @company)
    assert_equal({}, @emp_package.additional_package_for_month)
    assert_equal @emp_package.basic*12, @emp_package.ctc
  end

  def test_ctc_when_we_have_simple_allowance_calculator_and_have_allowances
    setup
    Factory(:simple_allowance_company_calculator, :company => @company)
    Factory(:employee_package_head, :company => @company, :employee => @emp_package.employee,
      :salary_head => Factory(:hra), :employee_package => @emp_package)
    @emp_package.reload
    assert_not_equal({}, @emp_package.additional_package_for_month)
    assert_equal 126000.0, @emp_package.ctc
  end

  def test_additional_package_for_month
    setup
    Factory(:simple_allowance_company_calculator, :company => @company)
    Factory(:employee_package_head, :company => @company, :employee => @emp_package.employee,
      :salary_head => Factory(:hra), :employee_package => @emp_package)
    @emp_package.reload
    assert_not_equal({}, @emp_package.additional_package_for_month)
  end

  def test_total_for_month
    setup
    Factory(:simple_allowance_company_calculator, :company => @company)
    Factory(:employee_package_head, :company => @company, :employee => @emp_package.employee,
      :salary_head => Factory(:hra), :employee_package => @emp_package)
    @emp_package.reload
    assert_equal(10500.0, @emp_package.total_for_month)
  end
  
  def test_ended
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => Date.parse("1 Jan 2007"), :end_date => Date.parse("31 oct 2009"))
    assert emp_package.ended?
  end

  def test_period
    setup   
    assert_equal("Jan 2007 - ", @emp_package.period)
  end

  def test_applicable_for_month_if_package_is_active_and_start_before_month
    setup_for_applicability
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => @run_date - 1.months)
    assert emp_package.active?
    assert emp_package.applicable_for_month?(@start_date, @end_date)
  end

  def test_applicable_for_month_if_package_is_active_and_start_in_month
    setup_for_applicability
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => @run_date - 1.day)
    assert emp_package.active?
    assert emp_package.applicable_for_month?(@start_date, @end_date)
  end

  def test_applicable_for_month_if_package_is_active_and_start_after_month
    setup_for_applicability
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => @run_date + 1.months)
    assert emp_package.active?
    assert_equal(false,emp_package.applicable_for_month?(@start_date, @end_date))
  end

  def test_applicable_for_month_if_package_is_ended_and_start_before_and_end_in_month
    setup_for_applicability
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => @run_date - 1.months, :end_date => @run_date - 1.day)
    assert emp_package.ended?
    assert emp_package.applicable_for_month?(@start_date, @end_date)
  end

  def test_applicable_for_month_if_package_is_ended_and_start_before_and_end_before_month
    setup_for_applicability
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => @run_date - 3.months, :end_date => @run_date - 2.months)
    assert emp_package.ended?
    assert_equal(false,emp_package.applicable_for_month?(@start_date, @end_date))
  end

  def test_applicable_for_month_if_package_is_ended_and_start_in_and_end_after_month
    setup_for_applicability
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => @run_date - 20.day, :end_date => @run_date + 2.months)
    assert emp_package.ended?
    assert emp_package.applicable_for_month?(@start_date, @end_date)
  end

  def test_applicable_for_month_if_package_is_ended_and_start_in_and_end_in_month
    setup_for_applicability
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => @run_date - 20.day, :end_date => @run_date - 25.day)
    assert emp_package.ended?
    assert emp_package.applicable_for_month?(@start_date, @end_date)
  end

  def test_applicable_for_month_if_package_is_ended_and_start_before_and_end_after_month
    setup_for_applicability
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => @run_date - 5.months, :end_date => @run_date + 5.months)
    assert emp_package.ended?
    assert emp_package.applicable_for_month?(@start_date, @end_date)
  end

  def test_applicable_for_month_if_package_is_ended_and_start_after_and_end_after_month
    setup_for_applicability
    emp_package = Factory(:employee_package_10000, :company => Factory(:company),
      :start_date => @run_date + 5.months, :end_date => @run_date + 10.months)
    assert emp_package.ended?
    assert_equal(false,emp_package.applicable_for_month?(@start_date, @end_date))
  end

  private

  def setup_for_applicability
    @run_date ||= Date.parse("31 oct 2009")
    @start_date ||= @run_date.at_beginning_of_month
    @end_date ||= @run_date.end_of_month
  end
  
  def setup
    @company = Factory(:company)
    @emp_package = Factory(:employee_package_10000, :company => @company, :start_date => Date.parse("1 Jan 2007"))
  end
end
