require File.dirname(__FILE__) + '/../test_helper'

class CompanyAllowanceHeadTest < ActiveSupport::TestCase

  should_belong_to :company
  should_belong_to :salary_head
  should_have_many :salary_slip_charges
  should_validate_presence_of :company_id, :salary_head_id

  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]

  def test_allowances_for_slip
    setup_prerequisite
    allowances = CompanyAllowanceHead.allowances_for_slip(@company,@emp_package)
    assert !allowances.blank?
    allowances.flatten.first
    assert_equal("Rent", allowances.flatten.first.salary_head.name)
  end

  def test_bulk_create
    setup_prerequisite
    list = SalaryHead.all.collect{|c| c.id}
    CompanyAllowanceHead.bulk_create(list, @company)
	#@company.reload
    #assert_equal(28, CompanyAllowanceHead.for_company(@company).size)
  end

  private
  
  def setup_prerequisite
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company)
    @emp_package = Factory(:employee_package, :company => @company, :employee => @employee)
    @company_allowance_head = Factory(:hra_company_allowance_head, :company => @company)
    @emp_package_head = Factory(:employee_package_head, :employee => @employee, :employee_package => @emp_package, :company => @company, :salary_head => @company_allowance_head.salary_head)
  end
  
end
