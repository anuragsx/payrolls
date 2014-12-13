class CreateArrears < ActiveRecord::Migration
  def self.up
    create_table :arrears do |t|
      t.integer :employee_id
      t.integer :company_id
      t.integer :salary_slip_id
      t.float :amount
      t.string :description
      t.date :arrear_at
      t.timestamps
    end
    ArrearCalculator.create!(:type => "ArrearCalculator",
                             :name => "Arrear",:calculator_type => "Allowance"
                            )
    SalaryHead.create!(:name => "Arrear",:code => "arrear",:tax_formula => "TaxFormula")
  end

  def self.down
    drop_table :arrears
  end
end
