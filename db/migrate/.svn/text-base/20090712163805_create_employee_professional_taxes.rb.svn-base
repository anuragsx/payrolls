class CreateEmployeeProfessionalTaxes < ActiveRecord::Migration
  def self.up
    create_table :employee_professional_taxes do |t|
      t.integer :employee_id
      t.integer :company_id
      t.string :zone

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_professional_taxes
  end
end
