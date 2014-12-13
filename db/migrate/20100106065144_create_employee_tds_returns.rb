class CreateEmployeeTdsReturns < ActiveRecord::Migration
  def self.up
    create_table :employee_tds_returns do |t|
      t.integer :company_id
      t.integer :employee_id
      t.integer :tds_return_id
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_tds_returns
  end
end
