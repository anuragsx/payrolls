require File.dirname(__FILE__) + '/../test_helper'

class ExpenseClaimTest < ActiveSupport::TestCase

  should_belong_to :employee
  should_belong_to :company
  should_belong_to :salary_slip

  should_have_many :salary_slip_charges

  should_validate_presence_of :employee_id, :company_id, :amount, :description, :expensed_at
  should_validate_numericality_of :amount

  should_have_named_scope "for_employee(2)", :conditions => ["employee_id = ?",2]
  should_have_named_scope "for_company(2)", :conditions => ["company_id = ?",2]
  should_have_named_scope "expensed_in(Date.parse('2008-05-01'))", :conditions => ["month(expensed_at) = ? and year(expensed_at) = ?",5,2008]
  should_have_named_scope :unbilled, :conditions => ["salary_slip_id is null"]
  should_have_named_scope "in_years(2008)", :conditions => ["year(expensed_at) in (?)",2008]
  should_have_named_scope "in_months(5)", :conditions => ["month(expensed_at) in (?)",5]
  
end