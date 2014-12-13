class Department < ActiveRecord::Base

  attr_accessible :name, :company

  belongs_to :company
  has_many :employees
  #has_many :department_holidays
  #has_many :holidays, :through => :department_holidays

  validates :name, :company_id, :presence => true

  def deleteable?
    employees.count == 0
  end

end
