class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :name
      t.integer :employee_status_id
      t.date :commencement_date
      t.integer :company_id
      t.integer :department_id
      t.string :account_number

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
