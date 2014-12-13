require File.dirname(__FILE__) + '/../../test_helper'

class CompanyLeavesHelperTest < ActionView::TestCase
  
  def test_show_leave_accrual
    cl = Factory(:company_leave)
    output = show_leave_accrual(cl)
    assert output
    assert_equal("Earn now consume next year", output)
  end
  
end
