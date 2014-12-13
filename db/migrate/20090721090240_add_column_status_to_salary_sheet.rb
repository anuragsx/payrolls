class AddColumnStatusToSalarySheet < ActiveRecord::Migration
  def self.up
    add_column :salary_sheets, :status, :string
  end

  def self.down
    remove_column :salary_sheets, :status
  end
end
