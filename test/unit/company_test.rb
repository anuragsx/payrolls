require File.dirname(__FILE__) + '/../test_helper'

class CompanyTest < ActiveSupport::TestCase

  should_have_one :owner
  should_have_one :bank
  should_have_many :departments
  should_have_many :users
  should_have_many :employees
  should_have_many :active_employees
  should_have_many :salary_sheets
  should_have_many :salary_slips
  should_have_many :company_calculators
  should_have_many :calculators
  should_have_many :employee_packages
  should_belong_to :package
  #should_have_many :leave_types, :through => :company_leaves
  should_have_one :address
  should_have_attached_file :logo

  should_validate_presence_of :name, :package
  should_ensure_length_in_range :subdomain, 3..20

  def test_calculator_exists?(cal_type)
    assert true
  end

  def test_leave_calculator
    setup_company
    leave_calc = @company.leave_calculator
    assert leave_calc.is_leave?
  end

  def test_package_calculator
    setup_company
    pkg_calc = @company.package_calculator
    assert_nil pkg_calc
    Factory(:simple_allowance_company_calculator, :company => @company)
    @company.reload
    assert_not_nil @company.package_calculator
    pkg_calc = @company.package_calculator
    assert_kind_of(Calculator,pkg_calc)
    assert_kind_of(SimpleAllowanceCalculator,pkg_calc)
    assert pkg_calc.is_package?
  end

  def test_allowance_calculators
    setup_company
    allowance_calc = @company.allowance_calculators
    assert allowance_calc.blank?
    Factory(:dearness_relief_company_calculator, :company => @company)
    @company.reload
    assert !@company.allowance_calculators.blank?
    allowance_calc = @company.allowance_calculators.first
    assert_kind_of(Calculator,allowance_calc)
    assert_kind_of(DearnessReliefCalculator,allowance_calc)
    assert allowance_calc.is_allowance?
  end

  def test_deduction_calculators
    setup_company
    ded_calc = @company.deduction_calculators
    assert ded_calc.blank?
    Factory(:employee_loan_company_calculator, :company => @company)
    Factory(:employee_advance_company_calculator, :company => @company)
    Factory(:insurance_company_calculator, :company => @company)
    @company.reload
    assert !@company.deduction_calculators.blank?
    assert_equal(3, @company.deduction_calculators.size)
    ded_calc = @company.deduction_calculators.first
    assert_kind_of(Calculator,ded_calc)
    assert_kind_of(LoanCalculator,ded_calc)
    assert ded_calc.is_deduction?
  end

  def test_subtotal_calculators
    setup_company
    Factory(:bonus_company_calculator, :company => @company)
    
    assert !@company.subtotal_calculators.blank?
    assert_equal(1, @company.subtotal_calculators.size)
    subtotal = @company.subtotal_calculators.first
    assert_kind_of(Calculator,subtotal)
    assert_kind_of(BonusCalculator,subtotal)
    assert subtotal.is_subtotal?
  end

  def test_has_calculator
    setup_company
    assert @company.has_calculator?(LeaveAccountingCalculator)
  end

  def test_calculator_exists
    setup_company
    assert @company.calculator_exists?(:leave_accounting)
  end

  def test_find_owner
    setup_company
    @user = Factory(:user, :company => @company)
    assert_not_nil @company.owner
    assert_kind_of(User, @company.owner)
  end

  def test_package_name
    setup_company
    Factory(:silver_package)
    @company.package_name="Silver"
    assert_not_nil @company.package
    assert_equal("Silver", @company.package.name)
    Factory(:platinum_package)
    @company.package_name="Platinum"
    assert_not_nil @company.package
    assert_equal("Platinum", @company.package.name)
  end

  def test_can_add_employees
    setup_company
    Factory(:arun_employee, :company => @company)
    Factory(:silver_package, :max_employees => 1)
    @company.package_name="Silver"
    assert !@company.can_add_employees?
  end

  def test_max_employees
    setup_company
    Factory(:silver_package, :max_employees => 1)
    @company.package_name = "Silver"
    assert_equal(1.to_s,@company.max_employees)
  end
  

  def test_assign_package
    Factory(:company, :package_id => Factory(:silver_package).id)
  end

  private

  def setup_company
    @company = Factory(:company)
    Factory(:leave_accounting_company_calculator, :company => @company)
  end

end