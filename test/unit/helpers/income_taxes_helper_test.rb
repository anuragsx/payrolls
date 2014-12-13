require File.dirname(__FILE__) + '/../../test_helper'

class IncomeTaxesHelperTest < ActionView::TestCase

  def test_fetch_income_bracket
    slab = Factory(:tax_slab)
    output = fetch_income_bracket(slab)
    assert output
    assert_equal("0 to 190000", output)
  end
  
end
