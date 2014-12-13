class AddColumnRoundInChargesInCompany < ActiveRecord::Migration
  def self.up
    add_column(:companies, :round_in_charges, :integer, :default => 1)
  end

  def self.down
    remove_column(:companies, :round_in_charges)
  end
end
