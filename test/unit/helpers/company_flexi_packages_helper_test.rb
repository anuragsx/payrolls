require File.dirname(__FILE__) + '/../../test_helper'

class CompanyFlexiPackagesHelperTest < ActionView::TestCase

  def test_lookup_categories
    @company = Factory(:company)
    Factory(:employee, :company => @company)
    output = lookup_categories("Company", @company)
    assert output
    assert_equal 0, output   
  end 
  
end
