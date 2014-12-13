class CreatePfTypes < ActiveRecord::Migration
  def self.up
    create_table :pf_types do |t|
      t.string :name
      t.string :type
      t.float :pension_percent
      t.float :epf_percent
      t.float :pf_basic_threshold
      t.float :admin_percent
      t.float :edli_percent
      t.float :inspection_percent
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :pf_types
  end
end
