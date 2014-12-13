require File.dirname(__FILE__) + '/../test_helper'

class SalaryHeadTest < ActiveSupport::TestCase

  should_have_many :salary_slip_charges

  should_validate_presence_of :name, :code, :tax_formula
  
  should_have_named_scope :allowance_compatible, :conditions => ["salary_head_type = ?",'Allowance']
  should_have_named_scope :subtotal_compatible, :conditions => ["salary_head_type = ?",'SlipSubtotal']
  should_have_named_scope :deduction_compatible, :conditions => ["salary_head_type = ?",'Deduction']

  def test_is_taxable
    head = Factory(:bonus)
    assert_equal(true,head.is_taxable?)  
  end

  def test_is_taxable_with_false
    head = Factory(:tds)
    assert_equal(false,head.is_taxable?)
  end

  def test_short_name
    head = Factory(:tds)
    assert_equal("Tds", head.short_name)   
  end

  def test_short_name_with_nil
    head = Factory(:pension_fund_contrib)
    assert_equal("Pension", head.short_name)
  end

  def test_calculate_taxable_amount
    head = Factory(:bonus)
    e = Factory(:employee)
    assert_equal(1000, head.calculate_taxable_amount(5000, 1000, e , Date.today))
    
  end
end
