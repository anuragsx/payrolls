class CreateCompanyProfessionalTaxes < ActiveRecord::Migration
  
  def self.up
    create_table :company_professional_taxes do |t|
      t.integer :company_id
      t.string :zone
      t.timestamps
    end
    remove_column(:employee_professional_taxes, :zone)
  end

  def self.down
    drop_table :company_professional_taxes
    add_column(:employee_professional_taxes,:zone)
  end
  
end
