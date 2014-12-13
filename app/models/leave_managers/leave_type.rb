class LeaveType < ActiveRecord::Base

  has_many :company_leaves
  has_many :companies, :through => :company_leaves

  validates :name, :presence => true

end
