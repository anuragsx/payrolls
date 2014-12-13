require File.dirname(__FILE__) + '/../test_helper'

class EmployeeProfessionalTaxTest < ActiveSupport::TestCase

  should_belong_to :company
  should_belong_to :employee
  should_have_many :salary_slip_charges

  should_validate_presence_of :employee_id, :company_id

  should_have_named_scope "for_employee(2)", :conditions => ["employee_id = ?",2]

end