class RenameColumnInCompany < ActiveRecord::Migration
  def self.up
    rename_column(:companies, :round_in_charges, :round_by)
  end

  def self.down
    rename_column(:companies, :round_by, :round_in_charges )
  end
end
