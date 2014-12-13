class CreateIncentives < ActiveRecord::Migration
 def self.up
    create_table :incentives do |t|
      t.integer :employee_id
      t.integer :company_id
      t.integer :salary_slip_id
      t.float :amount
      t.string :description
      t.date :incentive_at
      t.timestamps
    end
    IncentiveCalculator.create!(:type => "IncentiveCalculator",
                                :name => "Incentive",:calculator_type => "Allowance")
    SalaryHead.create!(:name => "Incentive",:code => "incentive",:tax_formula=>"TaxFormula")
  end

  def self.down
    drop_table :incentives
  end
end
