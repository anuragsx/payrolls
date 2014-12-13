class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.string :name
      t.string :max_employees
      t.text :description
      t.float :fee
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end
