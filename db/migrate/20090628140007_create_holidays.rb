class CreateHolidays < ActiveRecord::Migration
  def self.up
    create_table :holidays do |t|
      t.string :name
      t.integer :day
      t.integer :month
      t.integer :year
      t.string :region
      t.timestamps
    end
  end

  def self.down
    drop_table :holidays
  end
end
