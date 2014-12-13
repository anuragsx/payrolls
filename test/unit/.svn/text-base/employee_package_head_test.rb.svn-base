require File.dirname(__FILE__) + '/../test_helper'

class EmployeePackageHeadTest < ActiveSupport::TestCase

  should_belong_to :employee
  should_belong_to :company
  should_belong_to :employee_package
  should_belong_to :salary_head

  should_have_many :salary_slip_charges
  should_validate_presence_of :amount, :employee, :company
  should_validate_numericality_of :amount

  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]
  should_have_named_scope "for_employee(1)", :conditions => ["employee_id = ?",1]
  should_have_named_scope "for_head(1)", :conditions => ["salary_head_id = ?",1]
  should_have_named_scope "for_package(1)", :conditions => ["employee_package_id = ?",1]
  should_have_named_scope "for_code('basic')", :conditions => ["salary_head.code = ?",'basic'], :joins => [:salary_head]

  def test_leave_dependent
    leave = Factory(:employee_package_head)
    assert_equal(true, leave.leave_dependent)   
  end

end
