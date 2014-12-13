class CreateTaxCategories < ActiveRecord::Migration
  def self.up
    create_table :tax_categories do |t|
      t.string :category
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :tax_categories
  end
end
