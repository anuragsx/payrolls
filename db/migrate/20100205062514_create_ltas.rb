class CreateLtas < ActiveRecord::Migration
  def self.up
    create_table :ltas do |t|
      t.integer :company_id
      t.integer :employee_id
      t.float :amount
      t.string :description
      t.integer :salary_slip_id
      t.string :block
      t.timestamps
    end
    LtaCalculator.create(:name =>"LTA",:calculator_type => "Allowance")
    SalaryHead.create(:name => "LTA",:code => "lta",:tax_formula => "TaxFormula")
  end

  def self.down
    drop_table :ltas
  end
end
