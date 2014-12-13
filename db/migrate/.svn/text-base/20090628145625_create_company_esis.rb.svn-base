class CreateCompanyEsis < ActiveRecord::Migration
  def self.up
    create_table :company_esis do |t|
      t.integer :company_id
      t.string :esi_number
      t.integer :esi_type_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :company_esis
  end
end
