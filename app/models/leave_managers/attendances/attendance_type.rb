class AttendanceType < ActiveRecord::Base


  #TODO solving mass assignment.
  attr_accessible :name, :type

  has_many :attendances
  validates :name, :presence => true
  set_inheritance_column nil

  CASUAL_LEAVE = 'Casual'
  PRIVILEGE_LEAVE = 'Privilege'
  SICK_LEAVE  =  'Sick'
  PRESENT = 'Present'
  ABSENT = 'Absent'

  def self.collection
    self.all.collect{|t|[t.name,t.id]}
  end
  
  def is_present?
    self[:type] == PRESENT
  end

  def is_absent?
    self[:type] == ABSENT
  end
     
end
