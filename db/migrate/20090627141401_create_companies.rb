class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :phone_no
      t.string :subdomain
      t.integer :package_id
      t.integer :rate_of_leave
      t.string :bank
      t.string :account_number

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
