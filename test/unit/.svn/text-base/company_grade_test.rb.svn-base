require File.dirname(__FILE__) + '/../test_helper'

class CompanyGradeTest < ActiveSupport::TestCase
  
  should_belong_to :company
  should_have_many :employee_packages

  should_validate_presence_of :pay_scale, :company_id
end
