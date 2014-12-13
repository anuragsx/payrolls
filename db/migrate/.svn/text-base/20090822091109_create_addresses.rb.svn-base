class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :address_line1
      t.string :address_line2
      t.string :address_line3
      t.string :city
      t.string :pincode
      t.string :phone_number
      t.timestamps
    end
    Address.reset_column_information
    Company.all.each do |company|
      a = Address.new
      a.address_line1 = company.address if company.address
      a.phone_number = company.phone_no if company.phone_no
      a.save
    end
    add_column(:companies, :address_id, :integer)
    remove_column(:companies, :address, :phone_no)
  end

  def self.down
    drop_table :addresses
    add_column(:companies, :address, :string)
    add_column(:companies, :phone_no, :string)
  end
end
