class CreateEmployeeTaxes < ActiveRecord::Migration
  def self.up
    create_table :employee_taxes do |t|
      t.integer :employee_id
      t.integer :company_id
      t.float :amount, :default => 0
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_taxes
  end
end