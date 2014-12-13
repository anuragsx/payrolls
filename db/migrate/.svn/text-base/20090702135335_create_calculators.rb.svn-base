class CreateCalculators < ActiveRecord::Migration
  def self.up
    create_table :calculators do |t|
      t.string :name
      t.string :type
      t.string :calculator_type

      t.timestamps
    end
  end

  def self.down
    drop_table :calculators
  end
end
