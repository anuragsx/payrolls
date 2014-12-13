class ApprovalStatus < ActiveRecord::Base
  has_many :attendances
  validates_presence_of :name
end
