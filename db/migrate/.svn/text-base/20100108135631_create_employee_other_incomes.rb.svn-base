class CreateEmployeeOtherIncomes < ActiveRecord::Migration
  def self.up
    create_table :employee_other_incomes do |t|
      t.integer :company_id
      t.integer :employee_id
      t.float :amount
      t.integer :financial_year
      t.integer :salary_slip_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_other_incomes
  end
end
