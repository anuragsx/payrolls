class CreateTdsReturns < ActiveRecord::Migration
  def self.up
    create_table :tds_returns do |t|
      t.integer :company_id
      t.date :start_date
      t.string :receipt_number
      t.float :intrest_amount
      t.string :bsr_code
      t.string :cheque_ya_dd_no
      t.date :tax_deposited_date
      t.date :tax_deduction_date
      t.string :payment_made
      t.string :challan_serial_no
      t.timestamps
    end
  end

  def self.down
    drop_table :tds_returns
  end
end
