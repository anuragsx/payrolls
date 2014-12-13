require File.dirname(__FILE__) + '/../test_helper'

class EmployeeTaxTest < ActiveSupport::TestCase

  should_belong_to :employee
  should_belong_to :company
  #should_belong_to :salary_slip
  should_have_many :salary_slip_charges

  should_validate_presence_of :amount, :employee_id, :company_id
  should_validate_numericality_of :amount

  should_have_named_scope "for_employee(2)", :conditions => ["employee_id = ?",2]
  should_have_named_scope "after_date('2009-08-07')", :conditions => ["created_at < ?",'2009-08-07']
end
