require File.dirname(__FILE__) + '/../test_helper'

class CompanyHolidayTest < ActiveSupport::TestCase

  should_belong_to :company
  should_belong_to :holiday

  should_validate_presence_of :company_id, :holiday_id
end
