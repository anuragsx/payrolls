class AddDeleteAtToEmployeePension < ActiveRecord::Migration
  def self.up
    add_column :employee_pensions, :deleted_at, :datetime
  end

  def self.down
    remove_column :employee_pensions, :deleted_at
  end
end
