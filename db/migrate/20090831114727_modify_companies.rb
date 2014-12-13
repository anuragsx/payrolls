class ModifyCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :pan, :string
    add_column :companies, :tan, :string
    remove_column :companies, :rate_of_leave
  end

  def self.down
    remove_column :companies, :pan
    remove_column :companies, :pan
    add_column :companies, :rate_of_leave, :integer
  end
end
