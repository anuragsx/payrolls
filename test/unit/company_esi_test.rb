require File.dirname(__FILE__) + '/../test_helper'

class CompanyEsiTest < ActiveSupport::TestCase

  should_belong_to :company
  should_belong_to :esi_type

  should_validate_presence_of :company_id, :esi_type_id, :esi_number

  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]

  def test_esi_name
    setup_company_esi
    assert_equal("Factory Act", @company_esi.esi_type.try(:name))
  end

  def test_activate_on_all_employees
    setup_company_esi
    c = Factory(:company)
    @company_esi = Factory(:factory_company_esi, :company => c)
    @employee_esi = Factory(:employee_esi, :company => c)
    @company_esi.gross = 5000
    employee = Factory(:employee, :company => c)
    emp_package = Factory(:employee_package, :employee => employee)
    assert_not_nil  @company_esi.activate_on_all_employees
  end

  def test_eligible
    setup_company_esi
    assert_equal(true, @company_esi.eligible?(2000))
  end

  def test_employer_contrib
    setup_company_esi
    @company_esi.effective_base = 2000
    assert_equal(95, @company_esi.employer_contrib)
  end

  def test_employee_contrib
    setup_company_esi
    @company_esi.gross = 2000
    assert_not_nil @company_esi.employee_contrib
    assert_equal(-35.0, @company_esi.employee_contrib)
  end

  def test_employee_description
    setup_company_esi
    @company_esi.gross = 2000
    assert_equal("Employee ESI Contribution at 1.75% on 2000.0", @company_esi.employee_description)
  end

  def test_employer_description
    setup_company_esi
    @company_esi.effective_base = 2000
    assert_equal("Employer ESI Contribution at 4.75% on 2000.0", @company_esi.employer_description)
  end

  def test_create_employee
    setup_company_esi
    employee = Factory(:employee)
    assert_not_nil @company_esi.create_employee(employee)
  end

  private

  def setup_company_esi
    @company_esi = Factory(:factory_company_esi)
  end
end
