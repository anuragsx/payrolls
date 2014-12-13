class CreateEmployeeLeaveBalances < ActiveRecord::Migration
  def self.up
    create_table :employee_leave_balances do |t|
      t.integer :employee_id
      t.integer :company_id
      t.string :financial_year
      t.float :current_balance
      t.float :earned_leaves
      t.float :spent_leaves
      t.float :opening_balance

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_leave_balances
  end
end
