class CreateSalarySlipCharges < ActiveRecord::Migration
  def self.up
    create_table :salary_slip_charges do |t|
      t.integer :employee_id
      t.integer :company_id
      t.integer :salary_sheet_id
      t.integer :salary_slip_id
      t.integer :salary_head_id
      t.float :amount
      t.string :reference_type
      t.integer :reference_id
      t.string :description
      t.float :base_charge
      t.date :charge_date
      t.string :financial_year
      t.timestamps
    end
  end

  def self.down
    drop_table :salary_slip_charges
  end
end
