require File.dirname(__FILE__) + '/../../test_helper'

class CompaniesHelperTest < ActionView::TestCase
  
  def test_company_settings_links
    @company = Factory(:company)    
    Factory(:dearness_relief_company_calculator, :company => @company)
    Factory(:bonus_company_calculator, :company => @company)
    output = company_settings_links
    assert output
  end

  def link_active?(bool_condition = false)
    (bool_condition && "active") || ""
  end

  def params
    { :controller => 'companies'}
  end

  def current_account
    @company ||= Company.find_by_subdomain('', :include => [:calculators])
  end

  def test_companies_sub_header
    @company = Factory(:company)    
    output = companies_sub_header
    assert output
  end

end
