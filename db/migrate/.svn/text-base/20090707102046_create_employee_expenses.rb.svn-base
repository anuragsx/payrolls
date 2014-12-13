class CreateEmployeeExpenses < ActiveRecord::Migration
  def self.up
    create_table :reimbursements do |t|
      t.integer :employee_id
      t.integer :company_id
      t.string :description
      t.float :amount
      t.integer :salary_slip_id
      t.date :expensed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :reimbursements
  end
end
