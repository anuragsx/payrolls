require File.dirname(__FILE__) + '/../test_helper'

class CompanyPfTest < ActiveSupport::TestCase
  should_belong_to :company
  should_belong_to :pf_type
  should_have_many :employee_pensions
  should_have_many :salary_slip_charges
  should_validate_presence_of :company_id, :pf_type_id, :pf_number

  should_have_named_scope "for_company(2)", :conditions => ["company_id = ?",2]

  def test_activate_on_all_employees

    setup_company_pf
    c = Factory(:company)
    @company_pf = Factory(:company_pf, :company => c)
    employee = Factory(:employee, :company => c)
    emp_package = Factory(:employee_package, :employee => employee)
    assert_not_nil  @company_pf.activate_on_all_employees   
  end

  def test_pf_name
    setup_company_pf
    assert_equal("PF Type", @company_pf.pf_name)
  end

  def test_pf_number
    setup_company_pf
    assert_equal("23456", CompanyPf.pf_number(@company_pf.company))
  end

  private

  def setup_company_pf
    @company_pf = Factory(:company_pf, :pf_number => "23456")
  end

end
