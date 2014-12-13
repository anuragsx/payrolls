require File.dirname(__FILE__) + '/../test_helper'

class EmployeeInvestment80cTest < ActiveSupport::TestCase

  should_belong_to :company
  should_belong_to :employee
  should_belong_to :employee_investment_scheme
  should_belong_to :employee_tax_detail

  should_validate_presence_of :employee_id, :company_id,:employee_investment_scheme_id,:amount
  should_validate_numericality_of :amount

  should_have_named_scope "for_employee(1)", :conditions => ["employee_id = ?",1]


  def test_effective_investments
    setup
    assert_not_nil(EmployeeInvestment80c.effective_investments(@employee, Date.today))
    assert_equal(1, EmployeeInvestment80c.effective_investments(@employee, Date.today).length)
    assert_equal(1000, EmployeeInvestment80c.effective_investments(@employee, Date.today).first.amount)
    assert_equal(Date.today.year, EmployeeInvestment80c.effective_investments(@employee, Date.today).first.financial_year)
  end

  def test_total_investments
    setup
    assert_not_nil(EmployeeInvestment80c.total_investments(@employee, Date.today))
    assert_equal(1000,EmployeeInvestment80c.total_investments(@employee, Date.today))
  end

  def test_eligible_amount_invested
    setup
    assert_equal(5000, EmployeeInvestment80c.eligible_amount_invested(5000))
    assert_equal(100000, EmployeeInvestment80c.eligible_amount_invested(100001))
  end

  def test_set_financial_year
    setup
    assert_equal(2009,@invst.set_financial_year)
  end

  def test_created_at_before_type_cast
    setup
    assert_not_nil(@invst.created_at_before_type_cast)
  end

  private

  def setup
    @employee = Factory(:employee)
    @invst = Factory(:employee_investment80c, :employee => @employee)
  end
end
