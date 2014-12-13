class CreateEmployeeLoans < ActiveRecord::Migration
  def self.up
    create_table :employee_loans do |t|
      t.integer :employee_id
      t.integer :company_id
      t.float :loan_amount
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_loans
  end
end
