class RemoveColumnFinancialYearFromEmployeeTaxDetails < ActiveRecord::Migration
  def self.up
    remove_column :employee_tax_details, :financial_year
  end

  def self.down
    add_column :employee_tax_details, :financial_year, :integer
  end
end
