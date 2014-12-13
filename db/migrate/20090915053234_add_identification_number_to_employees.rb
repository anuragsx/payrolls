class AddIdentificationNumberToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :identification_number, :string
  end

  def self.down
    remove_column :employees, :identification_number
  end
end