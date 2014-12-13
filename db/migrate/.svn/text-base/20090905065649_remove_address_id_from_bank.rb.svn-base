class RemoveAddressIdFromBank < ActiveRecord::Migration
  def self.up
    remove_column :banks, :address_id
    remove_column :employees, :address_id
    remove_column :companies, :address_id
  end

  def self.down
    add_column :banks, :address_id, :integer
    add_column :employees, :address_id, :integer
    add_column :companies, :address_id, :integer
  end
end
