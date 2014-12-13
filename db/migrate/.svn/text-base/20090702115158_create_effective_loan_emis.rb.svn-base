class CreateEffectiveLoanEmis < ActiveRecord::Migration
  def self.up
    create_table :effective_loan_emis do |t|
      t.integer :employee_loan_id
      t.integer :employee_id
      t.float :amount
      t.timestamps
    end
  end

  def self.down
    drop_table :effective_loan_emis
  end
end
