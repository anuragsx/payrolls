class RemoveBankAndAccountNumberFromCompanies < ActiveRecord::Migration
  def self.up
    remove_column(:companies, :bank)
    remove_column(:companies, :account_number)
  end

  def self.down
    add_column(:companies, :bank, :string)
    add_column(:companies, :account_number, :integer)
  end
end
