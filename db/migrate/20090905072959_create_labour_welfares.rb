class CreateLabourWelfares < ActiveRecord::Migration
  def self.up
    create_table :labour_welfares do |t|
      t.string :zone
      t.integer :submissions_count
      t.string :paid_to
      t.timestamps
    end
  end

  def self.down
    drop_table :labour_welfares
  end
end
