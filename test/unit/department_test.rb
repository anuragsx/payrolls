require File.dirname(__FILE__) + '/../test_helper'

class DepartmentTest < ActiveSupport::TestCase

  should_have_many :employees
  should_belong_to :company
  should_validate_presence_of :name, :company_id

  def test_deleteable
    setup_department
    assert(@department.employees.size == 0)
    assert @department.deleteable?
    Factory(:employee, :department => @department)
    assert !@department.deleteable?
  end

  private

  def setup_department
    @department = Factory(:department)
  end
  
end
