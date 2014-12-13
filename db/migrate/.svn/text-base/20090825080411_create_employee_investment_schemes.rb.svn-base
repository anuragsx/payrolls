class CreateEmployeeInvestmentSchemes < ActiveRecord::Migration
  def self.up
    create_table :employee_investment_schemes do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    remove_column :employee_tax_details,:investment_details
  end

  def self.down
    drop_table :employee_investment_schemes
    add_column :employee_tax_details,:investment_details,:float
  end
end
