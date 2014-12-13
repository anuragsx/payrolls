class AddColumnsToEmployeeLeaves < ActiveRecord::Migration
  def self.up
    add_column :employee_leaves, :late_hours, :float
    add_column :employee_leaves, :overtime_hours, :float
  end

  def self.down
    remove_column :employee_leaves, :late_hours
    remove_column :employee_leaves, :overtime_hours
  end
end
