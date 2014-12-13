class AddColumnMobileNumberInAddress < ActiveRecord::Migration
  def self.up
    add_column(:addresses, :mobile_number, :string)
  end

  def self.down
    remove_column(:addresses, :mobile_number)
  end
end
