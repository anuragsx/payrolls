class AddExtraWorkDaysToEmployeeLeaves < ActiveRecord::Migration
  def self.up
    add_column :employee_leaves, :extra_work_days, :float
  end

  def self.down
    remove_column :employee_leaves, :extra_work_days
  end
end
