require File.dirname(__FILE__) + '/../test_helper'

class TaxSlabTest < ActiveSupport::TestCase

  should_belong_to :tax_category
  should_have_named_scope "applied_slab('232')", :conditions => ["min_threshold <= ?", '232']
  should_have_named_scope "for_category(1)", :conditions => ["tax_category_id = ?", 1],:order => "max_threshold ASC"

  def test_tax_amount
    assert_equal(0.0,TaxSlab.tax_amount(1,200, Date.today))
  end
end
