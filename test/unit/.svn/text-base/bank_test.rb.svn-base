require File.dirname(__FILE__) + '/../test_helper'


class BankTest < ActiveSupport::TestCase
  should_belong_to :company
  should_have_one :address
  should_validate_presence_of :company_account_number,:name

  def test_complete_address
    bank = Factory(:bank)
    Factory(:address)
    assert_equal("address_line1, address_line2, address_line3, Jaipur, Pin Code : 302020, Rajasthan", bank.complete_address)   
  end
end
