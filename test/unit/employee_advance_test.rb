require File.dirname(__FILE__) + '/../test_helper'

class EmployeeAdvanceTest < ActiveSupport::TestCase
  should_belong_to :company
  should_belong_to :employee
  should_belong_to :salary_slip
  should_have_many :salary_slip_charges
  should_validate_presence_of :employee_id, :company_id, :amount, :created_at
  should_validate_numericality_of :amount

  should_have_named_scope :unbilled, :conditions => "salary_slip_id is null"
  should_have_named_scope "for_company(1)", :conditions => ["employee_advances.company_id = ?",1]
  should_have_named_scope "in_year(2009)", :conditions => ["year(created_at) = ?",2009]
  should_have_named_scope "for_date('2008-01-01')", :conditions => ["created_at <= ?",'2008-01-01']
  should_have_named_scope "for_employee(2)", :conditions => ["employee_id = ?",2]
  should_have_named_scope "find_by_years(2008)", :conditions => ["year(created_at) in (?)",2008]
  should_have_named_scope "find_by_months(3)", :conditions => ["month(created_at) in (?)", 3]
  #should_have_named_scope "in_fy(2008)", :conditions => ["created_at >= ? and created_at <= ?", 'Tue, 01 Apr 2008', 'Tue, 31 Mar 2009']

  
end
