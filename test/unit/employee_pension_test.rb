require File.dirname(__FILE__) + '/../test_helper'

class EmployeePensionTest < ActiveSupport::TestCase
  should_belong_to :employee
  should_belong_to :company
  should_belong_to :company_pf

  should_have_many :salary_slip_charges
  should_validate_presence_of :company_pf

  should_have_named_scope "for_company(2)", :conditions => ["company_id = ?",2]
  should_have_named_scope "for_employee(2)", :conditions => ["employee_id = ?",2]
  #should_have_named_scope "eligible('2008-05-07')", :conditions => ["(deleted_at is null or deleted_at = '')
  #                                                    or (month(deleted_at) = ? and year(deleted_at) = ?)",5,2008]
  should_have_named_scope "for_date('2008-05-07')", :conditions => ["created_at < ?",'2008-05-07'],
                                                                    :order => 'created_at desc',
                                                                    :limit => 1
#  should_have_named_scope "joined_in_month('2008-05-07')", :conditions => ["month(created_at) = ? and year(created_at) = ?",'5','2008']
#  should_have_named_scope "left_in_month('2008-05-07')", :conditions => ["month(deleted_at) = ? and year(deleted_at) = ?",'5','2008']

  
  def test_pf_type
    setup
    assert_not_nil(@emp_pension.pf_type)  
  end

  def test_created_at_before_type_cast
    setup   
    assert_equal(Date.today.to_s(:date_month_and_year), @emp_pension.created_at_before_type_cast)
  end

  def test_deleted_at_before_type_cast
    emp_pension = Factory(:employee_pension, :created_at => Date.today - 2.days,:deleted_at => Date.today)
    assert_equal(Date.today.to_s(:date_month_and_year), emp_pension.deleted_at_before_type_cast)
  end

  def test_deleted
    setup    
    assert_equal(false, @emp_pension.deleted?)
  end

  def test_epf_for_employee
    setup    
    assert_not_nil(EmployeePension.epf_for_employee(@emp_pension.employee))
  end

  def test_fix_date
    setup
    assert_not_nil(@emp_pension.fix_date)
  end
  
  private

  def setup
    @emp_pension = Factory(:employee_pension)
  end

end
