require File.dirname(__FILE__) + '/../test_helper'

class SalarySheetTest < ActiveSupport::TestCase

  should_belong_to :company
  should_have_many :salary_slips
  should_have_many :salary_slip_charges
  should_have_many :salary_slips_with_includes
  should_validate_presence_of :run_date, :company


  should_have_named_scope "salary_sheet_for(Date.today)", :conditions => {:run_date => Date.today.end_of_month}
  should_have_named_scope "for_company(2)", :conditions => {:company_id => 2}
  should_have_named_scope "in_fy('2009')", :conditions => {:financial_year => '2009'}
  should_have_named_scope "for_month(Date.today)", :conditions => ["month(run_date) = ? and year(run_date) = ?",Date.today.month,Date.today.year]
  should_have_named_scope "after_date('2009-05-07')", :conditions => ["run_date > ?",'2009-05-07']
  should_have_named_scope "between_date('2009-05-07','2009-09-07')", :conditions => ["run_date >= ? &&  run_date <= ?",'2009-05-07','2009-09-07']

  def setup
    @company = Factory(:company)       
    Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:basic_company_calculator, :company => @company, :position => 2 )
    Factory(:pf_company_calculator, :company => @company, :position => 3 )
    Factory(:company_pf, :company => @company)
    @run_date = Date.today - 1
  end
  
  def test_creating_and_finalize_salary_sheet
    
    @employee = Factory(:employee, :company => @company)
    Factory(:employee_package, :company => @company, :employee => @employee, :basic => 10000.00)
    Factory(:employee_leave, :company => @company, :employee => @employee, :absent => 2,  :salary_slip => nil, :salary_sheet => nil,
      :created_at => @run_date)
    s = Factory(:salary_sheet, :company => @company, :run_date => @run_date)
    assert_not_nil(s)
    assert_kind_of(Array, s.salary_slips)
    s.salary_slips.each do |slip|
      charges  = slip.salary_slip_charges
      assert_kind_of(Array, charges)
      charges.each do |ch|
        assert_not_nil(ch.salary_sheet_id)
      end
    end
  end

  def test_unfinalizing_salary_sheet
    @employee = Factory(:employee, :company => @company)
    Factory(:employee_package, :company => @company, :employee => @employee, :basic => 10000.00)
    s = Factory(:salary_sheet, :company => @company, :run_date => @run_date)
    assert_not_nil(s)
    assert_kind_of(Array, s.salary_slips)
    s.salary_slips.each do |slip|
      charges  = slip.salary_slip_charges
      assert_kind_of(Array, charges)
      charges.each do |ch|
        assert_not_nil(ch.salary_sheet_id)
      end
    end
    s.reload
    s.unfinalize!
    assert_kind_of(Array, s.salary_slips)
    s.salary_slips.each do |slip|
      charges  = slip.salary_slip_charges
      assert_kind_of(Array, charges)
    end
  end

  def test_unfinalize_sheet
    # Take a salary Slip charges and unfinalize that charge sheet
  end


end

