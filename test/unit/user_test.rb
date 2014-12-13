require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should_belong_to :company
  should_have_one :address
  should_validate_presence_of :email, :message => "Cannot be left blank"
  should_validate_presence_of :login, :message => "Cannot be left blank"
  
end
