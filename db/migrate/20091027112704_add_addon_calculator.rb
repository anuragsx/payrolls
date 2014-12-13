class AddAddonCalculator < ActiveRecord::Migration
  def self.up
    AttendanceCalculator.create!(:name => "Attendance Calculator", :calculator_type => 'Addon')
    AttendanceType.create(:name => "Casual Leave")
    AttendanceType.create(:name => "Privilege Leave")
    AttendanceType.create(:name => "Sick leave")
  end

  def self.down
  end
end
