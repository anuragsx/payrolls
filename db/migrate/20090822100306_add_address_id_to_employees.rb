class AddAddressIdToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :address_id, :integer
  end

  def self.down
    remove_column :employees, :address_id
  end
end
