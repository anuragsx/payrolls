require File.dirname(__FILE__) + '/../test_helper'

class EmployeeEsiTest < ActiveSupport::TestCase
  should_belong_to :employee
  should_belong_to :company
  should_have_many :salary_slip_charges
  should_validate_presence_of :employee_id, :company_id

  should_have_named_scope "for_employee(1)", :conditions => ["employee_id = ?",1]
  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]
  should_have_named_scope "for_date('2008-01-01')",:conditions => ["effective_date < ?",'2008-01-01'], :order => 'effective_date desc', :limit => 1
end
