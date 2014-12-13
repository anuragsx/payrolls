require File.dirname(__FILE__) + '/../test_helper'

class CompanyProfessionalTaxTest < ActiveSupport::TestCase
  should_belong_to :company
  should_validate_presence_of :zone, :company_id

  should_have_named_scope "for_company(2)", :conditions => ["company_id = ?",2]
end
