class AddColumnStatusInEmployees < ActiveRecord::Migration
  def self.up
    add_column(:employees,:status,:string)
    
    Employee.all.each do |e|
      status = EmployeeStatus.find(e.employee_status_id)
      e.status = status.name.downcase
      e.save!
    end
    remove_column(:employees,:employee_status_id)
  end

  def self.down
    remove_column(:employees,:status)
    add_column(:employees,:employee_status_id)
  end
end
