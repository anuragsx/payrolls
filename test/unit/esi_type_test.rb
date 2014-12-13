require File.dirname(__FILE__) + '/../test_helper'

class EsiTypeTest < ActiveSupport::TestCase

  should_validate_presence_of :name, :employee_size, :employee_contrib_percent,
    :employer_contrib_percent, :basic_threshold
end
