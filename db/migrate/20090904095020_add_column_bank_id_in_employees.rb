class AddColumnBankIdInEmployees < ActiveRecord::Migration
  def self.up
    add_column(:employees, :bank_id, :integer)
  end

  def self.down
    remove_column(:employees, :bank_id)
  end
end
