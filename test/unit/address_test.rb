require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < ActiveSupport::TestCase

  should_belong_to :addressable

  def test_pin_code_with_label
    setup_user
    assert_equal("Pin Code : 302020", @address.pin_code_with_label)
  end

  def test_complete_addresslines
    setup_user
    assert_equal("address_line1, address_line2, address_line3", @address.complete_addresslines)
  end

  def test_complete_address
    setup_user
    assert_equal("address_line1, address_line2, address_line3, Jaipur, Pin Code : 302020, Rajasthan", @address.complete_address)
  end

  def test_check_mobile_format
    setup_user
    assert_nil @address.mobile_number
  end

  def  test_mobile_format_must_be_changed
    user = Factory.build(:address, :mobile_number => "+91 9928158093")
    assert user.save
    assert_equal("+919928158093", user.mobile_number)
  end


  private

  def setup_user
    @address = Factory(:address)
  end

end
