class CreateEsiTypes < ActiveRecord::Migration
  def self.up
    create_table :esi_types do |t|
      t.string :name
      t.integer :employee_size
      t.float :employer_contrib_percent
      t.float :employee_contrib_percent
      t.float :basic_percent
      t.float :basic_threshold
      t.timestamps
    end
  end
  
  def self.down
    drop_table :esi_types
  end
end
