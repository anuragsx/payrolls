class Holiday < ActiveRecord::Base

  validates_presence_of :name, :day, :month, :year, :region

end
