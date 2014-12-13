require File.dirname(__FILE__) + '/../test_helper'

class EmployeeLoanTest < ActiveSupport::TestCase
  should_belong_to :employee
  should_belong_to :company
  should_have_many :effective_loan_emis
  should_have_many :salary_slip_charges

  should_validate_presence_of :loan_amount, :employee_id, :company_id
  should_validate_numericality_of :loan_amount

  should_have_named_scope "for_employee(2)", :conditions => ["employee_id = ?",2]
  should_have_named_scope "after_date('2009-05-07')", :conditions => ["created_at < ?",'2009-05-07']
  should_have_named_scope "in_month(Date.parse('2009-05-07'))", :conditions => ["month(created_at) = ? and year(created_at) = ?",5,2009]


  private

  def setup
    @emp_loan = Factory(:employee_loan)
  end
end
