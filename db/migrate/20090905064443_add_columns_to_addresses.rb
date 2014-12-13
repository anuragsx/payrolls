class AddColumnsToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :addressable_type, :string
    add_column :addresses, :addressable_id, :int
  end

  def self.down
    remove_column :addresses, :addressable_id
    remove_column :addresses, :addressable_type
  end
end
