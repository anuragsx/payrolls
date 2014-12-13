require File.dirname(__FILE__) + '/../test_helper'

class FlexibleAllowanceTest < ActiveSupport::TestCase
  def setup
    @flexible_all = Factory.build(:flexible_allowance)
  end
  
  #  should_belong_to :company
  #  should_belong_to :salary_head
  #  should_belong_to :category
  #  should_belong_to :company_flexi_package
  #  should_have_many :salary_slip_charges
  #
  #  should_have_named_scope "for_company(2)", :conditions => ["company_id = ?",2]
  #  should_have_named_scope "for_category('Employee',1)", :conditions => ["category_type = ? and category_id = ?","Employee",1]
  #  should_have_named_scope "for_head(2)", :conditions => ["salary_head_id = ?",2]
  #
  #  should_validate_presence_of :company_id, :salary_head_id, :value,:company_flexi_package_id
  #  should_validate_presence_of :head_type, :category_id, :category_type

  def test_field_charge   
    assert_equal(40.0, @flexible_all.field_charge(2000, 2))
  end

  def test_fixed_value
    assert_equal(20.0, @flexible_all.fixed_value(2000))   
  end

  def test_category_that_can_be_added
    assert_equal(true, FlexibleAllowance.category_that_can_be_added(1,1,"Company"))
  end

  def test_category_that_can_be_added_for_employee
    c= Factory(:company)   
    assert_equal(false, FlexibleAllowance.category_that_can_be_added(c,1,"Employee"))
  end 
  
end