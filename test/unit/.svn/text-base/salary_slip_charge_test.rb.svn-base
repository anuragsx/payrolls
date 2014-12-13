require File.dirname(__FILE__) + '/../test_helper'

class SalarySlipChargeTest < ActiveSupport::TestCase

  should_belong_to :employee
  should_belong_to :salary_slip
  should_belong_to :salary_sheet
  should_belong_to :company
  should_belong_to :salary_head
  should_belong_to :reference

  should_validate_presence_of :amount, :salary_head_id, :charge_date

  should_have_named_scope :billed, :conditions => "salary_sheet_id is not null"
  should_have_named_scope "for_employee(2)", :conditions => ["employee_id = ?",2]
  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]
  should_have_named_scope "under_head(2)", :conditions => ["salary_head_id = ?",2]
  should_have_named_scope "on_salary_slip(3)", :conditions => ["salary_slip_id = ?",3]
  should_have_named_scope "on_salary_sheet(2)", :conditions => ["salary_sheet_id = ?",2]
  should_have_named_scope "in_fy('2008')", :conditions => ["financial_year = ?",'2008']
  #should_have_named_scope "upto_date_within_fy('2008','2008-05-07')", :conditions => ["salary_sheets.financial_year = ? && salary_sheets.run_date <= ?",'2008','2008-05-07']
  should_have_named_scope "between_date('2008-05-07','2009-05-07')", :conditions => ["charge_date >= ? &&  charge_date <= ?",'2008-05-07','2009-05-07']

end
