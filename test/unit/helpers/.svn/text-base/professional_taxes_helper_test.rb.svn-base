require File.dirname(__FILE__) + '/../../test_helper'

class ProfessionalTaxesHelperTest < ActionView::TestCase

  def test_get_status
    pf_tax = Factory(:professional_tax_slab)
    output = get_status(pf_tax)
    assert output
    assert_equal("Deregister from Professional Tax", output)
  end
end
