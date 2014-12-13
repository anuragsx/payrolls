require File.dirname(__FILE__) + '/../test_helper'

class PackageTest < ActiveSupport::TestCase

  should_have_many :companies

  should_validate_presence_of :name, :code, :fee, :max_employees

  def test_descriptive_name
    p = Factory(:gold_package)
    assert_equal("Gold at 1500.0", p.descriptive_name)
  end

end
