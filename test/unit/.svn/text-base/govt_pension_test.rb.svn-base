require File.dirname(__FILE__) + '/../test_helper'

class  GovtPensionTest < ActiveSupport::TestCase

  def setup
    @gv_pension = Factory(:govt_pension)
  end

  def test_effective_base_for_company
    assert_equal(10400.0, @gv_pension.effective_base_for_company(10000,200,300))
  end

  def test_effective_base_for_employee
    assert_equal(10300.0, @gv_pension.effective_base_for_employee(10000,200,300))
  end

  def test_effective_employee_percent
    assert_equal(8.33, @gv_pension.effective_employee_percent)
  end

  def test_employer_charges
    assert_not_nil(@gv_pension.employer_charges(6000,0))
  end  
  
end