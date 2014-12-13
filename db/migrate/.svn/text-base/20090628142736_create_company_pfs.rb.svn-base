class CreateCompanyPfs < ActiveRecord::Migration
  def self.up
    create_table :company_pfs do |t|
      t.integer :company_id
      t.integer :pf_type_id
      t.string :pf_number
      t.timestamps
    end
  end
  
  def self.down
    drop_table :company_pfs
  end
end
