require File.dirname(__FILE__) + '/../test_helper'

class EmployeeLeaveBalanceTest < ActiveSupport::TestCase

  should_belong_to :company
  should_belong_to :employee

  should_validate_presence_of :company_id, :employee_id
  should_validate_numericality_of :opening_balance, :current_balance, :earned_leaves, :spent_leaves

  should_have_named_scope "for_employee(2)", :conditions => ["employee_id = ?",2]
  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]
  should_have_named_scope "for_financial_year(2008)", :conditions => ["financial_year = ?",2008]
  should_have_named_scope :no_financial_year, :conditions => ["financial_year is null or financial_year =?", ""]

  def test_update_earning
    setup
    assert_equal(0.0, @emp_lve.earned_leaves)
    assert_equal(true, @emp_lve.update_earning!(18))
    assert_equal(18, @emp_lve.earned_leaves)
  end

  def test_update_current
    setup
    assert_equal(0.0, @emp_lve.current_balance)
    assert_equal(true, @emp_lve.update_current!(10))
    assert_equal(10, @emp_lve.current_balance)
  end
  
  def test_update_spend
    setup
    assert_equal(0.0, @emp_lve.spent_leaves)
    assert_equal(true, @emp_lve.update_spend!(10))
    assert_equal(10, @emp_lve.spent_leaves)
  end

  def test_degrade_earning
    setup
    assert_equal(0.0, @emp_lve.earned_leaves)
    assert_equal(true, @emp_lve.degrade_earning!(10))
    assert_equal(-10, @emp_lve.earned_leaves)
  end

  def test_degrade_current
    setup
    assert_equal(0.0, @emp_lve.spent_leaves)
    assert_equal(0.0, @emp_lve.current_balance)
    assert_equal(true, @emp_lve.degrade_current!(10))
    assert_equal(0.0, @emp_lve.spent_leaves)
    assert_equal(-10, @emp_lve.current_balance)
  end
  
  def test_degrade_spend
    setup
    assert_equal(0.0, @emp_lve.spent_leaves)
    assert_equal(0.0, @emp_lve.current_balance)
    assert_equal(true, @emp_lve.degrade_spend!(10))
    assert_equal(-10, @emp_lve.spent_leaves)
    assert_equal(10, @emp_lve.current_balance)
  end

  def test_create_empty_leave_balance
    setup
    new = EmployeeLeaveBalance.create_empty_leave_balance(@emp_lve.company, @emp_lve.employee)
    assert_equal(0.0,new.current_balance)
    assert_equal(0.0,new.opening_balance)
    assert_equal(0.0,new.earned_leaves)
    assert_equal(0.0,new.spent_leaves)
    assert_equal(2009,new.financial_year)    
  end

  def test_employee_added
    setup
    assert_equal([2007, 2008, 2009, 2010],EmployeeLeaveBalance.employee_added!(@emp_lve.employee))
  end

  private
  def setup
    @emp_lve = Factory(:employee_leave_balance)
  end
end

