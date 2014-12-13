class CreateBanks < ActiveRecord::Migration
  def self.up
    create_table :banks do |t|      
        t.string :name
        t.integer :company_id
        t.integer :address_id
        t.string :company_account_number
        t.timestamps
      end
    end

    def self.down
      drop_table :banks
    end
  end
