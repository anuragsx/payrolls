class AddColumnToCompanyPf < ActiveRecord::Migration
  def self.up
    add_column :company_pfs,:code_no,:string
  end

  def self.down
    remove_column :company_pfs,:code_no
  end
end
