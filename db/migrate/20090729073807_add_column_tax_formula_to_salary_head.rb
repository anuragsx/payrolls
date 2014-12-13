class AddColumnTaxFormulaToSalaryHead < ActiveRecord::Migration
  def self.up
    add_column :salary_heads, :tax_formula, :string
  end

  def self.down
    remove_column :salary_heads, :tax_formula
  end
end
