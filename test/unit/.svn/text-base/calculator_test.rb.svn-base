require File.dirname(__FILE__) + '/../test_helper'

class CalculatorTest < ActiveSupport::TestCase

  should_validate_presence_of :name, :type, :calculator_type

  should_have_named_scope :by_leave, :conditions => ["calculator_type = ?",'Leave']
  should_have_named_scope :by_package, :conditions => ["calculator_type = ?",'Package']
  should_have_named_scope :by_allowance, :conditions => ["calculator_type = ?",'Allowance']
  should_have_named_scope :by_deduction, :conditions => ["calculator_type = ?",'Deduction']
  should_have_named_scope :by_subtotal, :conditions => ["calculator_type = ?",'Subtotal']
  should_have_named_scope "in_type('Subtotal')", :conditions => ["calculators.type in (?)",'Subtotal']

  def test_is_leave
    @lv = Factory(:simple_leave_calculator)
    assert_equal(true, @lv.is_leave?)
  end

  def test_is_not_leave
    @lv = Factory(:simple_allowance_calculator)
    assert_equal(false, @lv.is_leave?)
  end

  def test_is_package
    @pack = Factory(:simple_allowance_calculator)
    assert_equal(true, @pack.is_package?)    
  end

  def test_is_not_package
    @pack = Factory(:simple_leave_calculator)
    assert_equal(false, @pack.is_package?)
  end

  def test_is_deduction
    @deduct = Factory(:advance_calculator)
    assert_equal(true, @deduct.is_deduction?)
  end

  def test_is_not_deduction
    @deduct = Factory(:simple_leave_calculator)
    assert_equal(false, @deduct.is_deduction?)
  end

  def test_is_allowance
    @allow = Factory(:dearness_relief_calculator)
    assert_equal(true, @allow.is_allowance?)
  end

  def test_is_not_allowance
    @allow = Factory(:advance_calculator)
    assert_equal(false, @allow.is_allowance?)
  end

  def test_is_subtotal
    @subt = Factory(:bonus_calculator)
    assert_equal(true, @subt.is_subtotal?)
  end

  def test_is_not_subtotal
    @subt = Factory(:advance_calculator)
    assert_equal(false, @subt.is_subtotal?)
  end

  def test_calculate_charge_for_sheet
    @subt = Factory(:bonus_calculator)
    assert_equal([], @subt.calculate_charge_for_sheet)
  end

  def test_eligible_for_employee
    @subt = Factory(:simple_allowance_calculator)
    assert_equal(true, @subt.eligible_for_employee?)
  end

  def test_eligible_for_sheet
    @subt = Factory(:simple_allowance_calculator)
    assert_equal(true, @subt.eligible_for_sheet?)
  end
  
  def test_leave_ratio
    @subt = Factory(:simple_allowance_calculator)
    assert_equal(1, @subt.leave_ratio)
  end
  
  def test_finalize
    @subt = Factory(:simple_allowance_calculator)
    assert_equal(true, @subt.finalize!)
  end

  def test_unfinalize
    @subt = Factory(:simple_allowance_calculator)
    assert_equal(true, @subt.unfinalize!)
  end
   
  def test_employee_added
    @subt = Factory(:simple_allowance_calculator)
    employee= Factory(:employee)
    assert_equal(true, @subt.employee_added!(employee))
  end

  def test_promote
    @pack = Factory(:simple_leave_calculator)
    emp_pack = Factory(:employee_package)
    assert_equal(true, @pack.promote!(emp_pack)) 
  end

  def test_suspend
    @pack = Factory(:simple_leave_calculator)
    emp_pack = Factory(:employee_package)
    assert_equal(true, @pack.suspend!(emp_pack))
  end

  def test_promote_employee
    @pack = Factory(:simple_leave_calculator)
    emp_pack = Factory(:employee_package)
    assert_equal(true, @pack.promote_employee!(emp_pack))
  end

  def test_suspend_employee
    @pack = Factory(:simple_leave_calculator)
    emp_pack = Factory(:employee_package)
    assert_equal(true, @pack.suspend_employee!(emp_pack))
  end

  def test_resume
    @pack = Factory(:simple_leave_calculator)
    emp_pack = Factory(:employee_package)
    assert_equal(true, @pack.resume!(emp_pack))
  end

  def test_resume_employee
    @pack = Factory(:simple_leave_calculator)
    emp_pack = Factory(:employee_package)
    assert_equal(true, @pack.resume_employee!(emp_pack))
  end

  def test_is_not_company_calculator
    company = Factory(:company)
    @pack = Factory(:simple_leave_calculator)
    assert_equal(false, @pack.is_company_calculator(company))
  end
  
  def test_is_company_calculator
    company = Factory(:company)
    @pack = Factory(:basic_company_calculator,:company => company)
    assert_equal(true, @pack.calculator.is_company_calculator(company))
  end

  def test_destroy_employee
    employee =  Factory(:employee)
    assert_equal([],Calculator.destroy_employee(employee))
  end

  def test_destroy_me
    company = Factory(:company)
    @pack = Factory(:basic_company_calculator,:company => company)
    assert_equal([],Calculator.destroy_me(@pack))
  end

  def test_leave_balance
    company = Factory(:company)
    @pack = Factory(:basic_company_calculator,:company => company)
    assert_equal(true, Calculator.leave_balance(@pack))
  end

  def test_bulk_create_leave_balance
    @subt = Factory(:simple_allowance_calculator)   
    assert_equal(true, @subt.bulk_create_leave_balance)
  end

  def test_delete_classes
    @subt = Factory(:simple_allowance_calculator)   
    assert_not_nil(@subt.delete_classes)
  end

  def test_controller_name
    @subt = Factory(:simple_allowance_calculator)
    assert_equal("SimpleAllowances", @subt.controller_name)
  end

  def test_company_classes
    @subt = Factory(:simple_allowance_calculator)
    assert_equal(nil, @subt.company_classes)
  end

  def test_is_ready
    @subt = Factory(:simple_allowance_calculator)
    assert_equal(nil, @subt.is_ready?)
  end

end
