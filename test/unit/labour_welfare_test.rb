require File.dirname(__FILE__) + '/../test_helper'

class LabourWelfareTest < ActiveSupport::TestCase

  should_have_many :labour_welfare_slabs
  
  should_validate_presence_of :zone,:submissions_count, :paid_to
  should_validate_numericality_of :submissions_count
end
