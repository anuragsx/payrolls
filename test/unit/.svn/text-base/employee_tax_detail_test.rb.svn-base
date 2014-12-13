require File.dirname(__FILE__) + '/../test_helper'

class EmployeeTaxDetailTest < ActiveSupport::TestCase

  should_belong_to :employee
  should_belong_to :company
  should_belong_to :tax_category
  should_have_many :employee_investment_80cs

  should_validate_presence_of :employee, :company, :tax_category

  should_have_named_scope "for_employee(2)", :conditions => ["employee_id = ?",2]

  def test_description
    setup
    assert_equal("Test Tax", @emp_tax_detail.description)
  end

  def test_financial_years
    setup
    assert_not_nil(EmployeeTaxDetail.financial_years)
    assert_equal(["2004-2005", 2004], EmployeeTaxDetail.financial_years.first)
    assert_equal(["2014-2015", 2014], EmployeeTaxDetail.financial_years.last)  
  end

  def test_tax_amount
    setup
    assert_equal(0.0, @emp_tax_detail.tax_amount(5000))
  end

  def test_pan_for_employee
    setup
    assert_equal("12345678", EmployeeTaxDetail.pan_for_employee(@emp_tax_detail.employee))
  end

  private

  def setup
    @emp_tax_detail = Factory(:employee_tax_detail)
  end
 
end
