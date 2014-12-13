class CreateEmployeeTaxDetails < ActiveRecord::Migration
  def self.up
    create_table :employee_tax_details do |t|
      t.integer :employee_id
      t.integer :company_id
      t.integer :tax_category_id
      t.float :investment_details
      t.string :pan
      t.integer :financial_year

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_tax_details
  end
end
