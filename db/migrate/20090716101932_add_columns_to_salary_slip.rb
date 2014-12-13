class AddColumnsToSalarySlip < ActiveRecord::Migration
  def self.up
    add_column :salary_slips, :doc_file_name, :string
    add_column :salary_slips, :doc_content_type, :string
  end
  def self.down
    remove_column :salary_slips, :doc_file_name
    remove_column :salary_slips, :doc_content_type
  end
end

