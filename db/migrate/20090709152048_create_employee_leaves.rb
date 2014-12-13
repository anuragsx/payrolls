
class CreateEmployeeLeaves < ActiveRecord::Migration
  def self.up
    create_table :employee_leaves do |t|
      t.integer :employee_id
      t.integer :company_id
      t.float :present
      t.float :absent
      t.integer :salary_sheet_id
      t.integer :salary_slip_id
      t.float :paid
      t.float :unpaid

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_leaves
  end
end
