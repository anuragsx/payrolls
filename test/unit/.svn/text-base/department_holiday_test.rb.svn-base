require File.dirname(__FILE__) + '/../test_helper'

class DepartmentHolidayTest < ActiveSupport::TestCase

  should_belong_to :department
  should_belong_to :company
  should_belong_to :holiday

  should_validate_presence_of :department_id, :company_id, :holiday_id
end
