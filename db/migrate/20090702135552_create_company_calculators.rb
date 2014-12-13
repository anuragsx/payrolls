class CreateCompanyCalculators < ActiveRecord::Migration
  def self.up
    create_table :company_calculators do |t|
      t.integer :company_id
      t.integer :calculator_id
      t.integer :position
      
      t.timestamps
    end
  end

  def self.down
    drop_table :company_calculators
  end
end
