class AddColumnToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :want_protected_pdf, :boolean
    add_column :companies, :pdf_password, :string
    add_column :companies, :default_employee_pdf_password, :string
    add_column :employees, :pdf_password, :string
  end

  def self.down
    remove_column :companies, :want_protected_pdf
    remove_column :companies, :pdf_password
    remove_column :companies, :default_employee_pdf_password
    remove_column :employees, :pdf_password
  end
end
