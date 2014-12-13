class CreateEmployeeInvestment80cs < ActiveRecord::Migration
  def self.up
    create_table :employee_investment80cs do |t|
      t.integer :employee_id
      t.integer :company_id
      t.integer :employee_investment_scheme_id
      t.float :amount
      t.integer :financial_year
      t.integer :employee_tax_detail_id
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_investment80cs
  end
end
