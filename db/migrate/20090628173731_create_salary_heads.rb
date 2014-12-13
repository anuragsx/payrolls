class CreateSalaryHeads < ActiveRecord::Migration
  def self.up
    create_table :salary_heads do |t|
      t.string :name
      t.string :salary_head_type
      t.string :code
      t.text :description
      t.timestamps
    end
  end
  
  def self.down
    drop_table :salary_heads
  end
end
