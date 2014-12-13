class AddColumnToSalarySlip < ActiveRecord::Migration
  def self.up
    add_column :salary_slips, :taxable_gross, :float
    add_column :salary_slips, :taxable_deduction, :float
  end

  def self.down
    remove_column :salary_slips, :taxable_gross
    remove_column :salary_slips, :taxable_deduction
  end
end
