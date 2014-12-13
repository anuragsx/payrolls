class CreateTaxSlabs < ActiveRecord::Migration
  def self.up
    create_table :tax_slabs do |t|
      t.float :min_threshold
      t.float :max_threshold
      t.float :tax_rate
      t.integer :tax_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tax_slabs
  end
end
