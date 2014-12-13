require File.dirname(__FILE__) + '/../../test_helper'

class InvestmentsHelperTest < ActionView::TestCase
  def test_financial_year_select
    output = financial_year_select
    assert output
  end

end
