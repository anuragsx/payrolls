require File.dirname(__FILE__) + '/../test_helper'

class EmployeeInsurancePolicyTest < ActiveSupport::TestCase

  should_belong_to :company
  should_belong_to :employee
  should_have_many :salary_slip_charges
  should_validate_presence_of :employee_id, :company_id, :monthly_premium, :name
  should_validate_numericality_of :monthly_premium

  should_have_named_scope "active_on('2009-01-14')", :conditions => ["(expiry_date is null or expiry_date > ?) and created_at < ?",'2009-01-14','2009-01-14']
  should_have_named_scope "for_employee(1)", :conditions => ["employee_id = ?",1]
  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]

  def test_description
    setup
    assert_not_nil(@employee_insurance.description)
  end

  def test_expired
    setup
    assert_equal(false,  @employee_insurance.expired?(Date.today))
  end

  def test_total_premium_paid
    setup
    assert_equal(0.0,@employee_insurance.total_premium_paid)  
  end

  def test_destroyable
    setup
    assert_equal(true, @employee_insurance.destroyable?)
  end 

  private

  def setup
    @employee_insurance = Factory(:employee_insurance_policy)
  end
  
end
