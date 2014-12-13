class AddComapnyIdToClientApplication < ActiveRecord::Migration
  def self.up
    add_column :client_applications, :company_id, :integer
    ClientApplication.reset_column_information
    ClientApplication.all.each do |cl|
      cl.update_attribute(:company_id, cl.user.company_id)
    end
  end

  def self.down
    remove_column :client_applications, :company_id
  end
end
