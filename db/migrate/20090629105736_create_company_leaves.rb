class CreateCompanyLeaves < ActiveRecord::Migration
  def self.up
    create_table :company_leaves do |t|
      t.integer :company_id
      t.integer :rate_of_leave
      t.integer :month_day_calculation
      t.float :month_length
      t.integer :leave_accrual
      t.timestamps
    end
  end
  
  def self.down
    drop_table :company_leaves
  end
end
