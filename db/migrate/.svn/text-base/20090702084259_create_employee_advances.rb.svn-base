class CreateEmployeeAdvances < ActiveRecord::Migration
  def self.up
    create_table :employee_advances do |t|
      t.integer :employee_id
      t.integer :company_id
      t.float :amount
      t.string :description
      t.integer :salary_slip_id

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_advances
  end
end
