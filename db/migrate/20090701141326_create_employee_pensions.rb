class CreateEmployeePensions < ActiveRecord::Migration
  def self.up
    create_table :employee_pensions do |t|
      t.integer :company_id
      t.integer :employee_id
      t.string :epf_number
      t.integer :company_pf_id
      t.float :total_pf_contribution
      t.float :vpf_amount
      t.float :vpf_percent
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_pensions
  end
end
