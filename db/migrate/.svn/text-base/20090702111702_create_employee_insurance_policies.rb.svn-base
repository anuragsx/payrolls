class CreateEmployeeInsurancePolicies < ActiveRecord::Migration
  def self.up
    create_table :employee_insurance_policies do |t|
      t.integer :company_id
      t.integer :employee_id
      t.float :monthly_premium
      t.date :expiry_date
      t.string :name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_insurance_policies
  end
end
