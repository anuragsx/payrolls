require File.dirname(__FILE__) + '/../test_helper'

class CompanyBonusTest < ActiveSupport::TestCase

  should_belong_to :company

  should_validate_presence_of :company_id, :release_date, :bonus_percent

  should_have_named_scope "for_company(1)", :conditions => {:company_id => 1}
  should_have_named_scope "for_date('2009-10-01')", :conditions => ["release_date >= ?", '2009-10-01'], :order => 'release_date', :limit => 1
  
end