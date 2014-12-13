class CreateEmployeeLeaveTypes < ActiveRecord::Migration
  def self.up
    create_table :employee_leave_types do |t|
      t.references :employee_leave
      t.references :company
      t.references :employee
      t.float :leaves
      t.float :paid
      t.float :unpaid
      t.float :earned
      t.float :spent
      t.string :leave_type
      t.timestamps
    end
    add_column :employee_leave_balances, :leave_type,:string
  end

  def self.down
    drop_table :employee_leave_types
    remove_column :employee_leave_balances, :attendance_type
  end
end
