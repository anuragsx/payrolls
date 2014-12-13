require File.dirname(__FILE__) + '/../test_helper'

class EffectiveLoanEmiTest < ActiveSupport::TestCase

  should_belong_to :employee
  should_belong_to :employee_loan

#  should_validate_presence_of :amount, :employee_loan_id
#  should_validate_numericality_of :amount

  should_have_named_scope "for_employee(1)", :conditions => ["employee_id = ?",1]
end