class AddColumnsExemptAmountToSalarySlipCharges < ActiveRecord::Migration
  def self.up
    add_column :salary_slip_charges, :taxable_amount, :float
  end

  def self.down
    remove_column :salary_slip_charges, :taxable_amount
  end
end
