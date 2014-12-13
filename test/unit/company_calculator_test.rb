require File.dirname(__FILE__) + '/../test_helper'

class CompanyCalculatorTest < ActiveSupport::TestCase

  should_belong_to :company
  should_belong_to :calculator
  should_validate_presence_of :company_id, :calculator_id, :position  

  should_have_named_scope :by_leave, :conditions=>["calculators.calculator_type = ?",'Leave'],:joins =>:calculator
  should_have_named_scope :by_package, :conditions=>["calculators.calculator_type = ?",'Package'],:joins =>:calculator
  should_have_named_scope :by_allowance, :conditions=>["calculators.calculator_type = ?",'Allowance'],:joins =>:calculator
  should_have_named_scope :by_deduction, :conditions=>["calculators.calculator_type = ?",'Deduction'],:joins =>:calculator
  should_have_named_scope :by_subtotal, :conditions=>["calculators.calculator_type = ?",'Subtotal'],:joins =>:calculator

  test "named_scope :by_leave" do
    setup_company
    leave_calc = @company.company_calculators.by_leave
    assert leave_calc.blank?
    Factory(:leave_accounting_company_calculator, :company => @company)
    @company.reload
    leave_calc = @company.company_calculators.by_leave
    assert !leave_calc.blank?
  end

  test "named_scope :by_package" do
    setup_company
    pkg_calc = @company.company_calculators.by_package
    assert pkg_calc.blank?
    Factory(:simple_allowance_company_calculator,:company => @company)
    @company.reload
    pkg_calc = @company.company_calculators.by_package
    assert !pkg_calc.blank?
    assert_kind_of(CompanyCalculator, pkg_calc.first)
  end

  private

  def setup_company
    @company = Factory(:company)
  end
  
end
