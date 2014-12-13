class CreateSalarySlips < ActiveRecord::Migration
  def self.up
    create_table :salary_slips do |t|
      t.integer :employee_id
      t.integer :company_id
      t.integer :salary_sheet_id
      t.float :unearned_leaves
      t.float :worked_days
      t.float :leaves
      t.float :leave_ratio
      t.float :net
      t.float :gross
      t.float :deduction
      t.timestamps
    end
  end

  def self.down
    drop_table :salary_slips
  end
end
