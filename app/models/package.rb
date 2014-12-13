class Package < ActiveRecord::Base

  attr_accessible :name, :max_employees, :fee, :code

  has_many :companies
  has_many :accounts
  
  validates :name, :code, :fee, :max_employees, :presence => true
  
  def descriptive_name
    "#{name} at #{fee}"
  end
 
  def to_param
    "#{name.to_safe_uri}"
  end
end
