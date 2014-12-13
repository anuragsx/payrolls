require File.dirname(__FILE__) + '/../test_helper'

class CompanyLoadingTest < ActiveSupport::TestCase

  should_belong_to :company
  should_have_many :salary_slip_charges
  
  should_validate_presence_of :company_id, :loading_percent
  should_validate_numericality_of :loading_percent

  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]
  should_have_named_scope "effective_for_date('2009-08-07')", :conditions => ["created_at < ?",'2009-08-07'], :order => 'created_at desc', :limit => 1
  
end
