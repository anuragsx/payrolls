class CreateLtaClaims < ActiveRecord::Migration
  def self.up
    create_table :lta_claims do |t|
      t.integer :company_id
      t.integer :employee_id
      t.string :claim_year
      t.string :block
      t.float :amount
      t.string :description
      t.integer :salary_slip_id
      t.integer :lta_id
      t.timestamps
    end
  end

  def self.down
    drop_table :lta_claims
  end
end
