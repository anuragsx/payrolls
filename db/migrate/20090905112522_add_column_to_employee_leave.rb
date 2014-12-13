class AddColumnToEmployeeLeave < ActiveRecord::Migration
  def self.up
    add_column :employee_leaves, :earned, :float
    add_column :employee_leaves, :spent, :float
  end

  def self.down
    remove_column :employee_leaves, :earned
    remove_column :employee_leaves, :spent
  end
end