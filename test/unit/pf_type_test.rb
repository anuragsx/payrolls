require File.dirname(__FILE__) + '/../test_helper'

class  PfTypeTest < ActiveSupport::TestCase

  should_validate_presence_of :name

  def test_effective_base_for_company
    assert_equal(0.0, @pf.effective_base_for_company(3000,300))
  end

  def test_effective_base_for_employee
    assert_equal(0.0, @pf.effective_base_for_employee(5000,200))   
  end

  def test_employer_charges
    assert_equal([], @pf.employer_charges)
  end

  def test_epf_contrib
    assert_equal(0, @pf.epf_contrib(200))
  end

  def test_admin_contrib
    assert_equal(0, @pf.admin_contrib(500))
  end

  def test_edli_contrib
    assert_equal(0, @pf.admin_contrib(500))
  end

  def test_inspection_contrib
    assert_equal(0, @pf.inspection_contrib(500))
  end

  def test_employer_charges_for_sheet
    assert_equal([], @pf.employer_charges_for_sheet(300))
  end

  private

  def setup
    @pf ||= Factory(:pf_type)
  end

end
