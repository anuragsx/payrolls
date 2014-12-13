class CreateProfessionalTaxSlabs < ActiveRecord::Migration
  def self.up
    create_table :professional_tax_slabs do |t|
      t.string :zone
      t.float :salary_min
      t.float :salary_max
      t.float :tax_amount
      t.integer :applicable_month
      t.date :applicable_date
      t.timestamps
    end
  end

  def self.down
    drop_table :professional_tax_slabs
  end
end
