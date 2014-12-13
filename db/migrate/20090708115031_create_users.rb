class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :login
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :login_count,:default=>0
      t.integer :failed_login_count,:default=>0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.string :perishable_token, :default => "", :null => false
      t.string :first_name
      t.string :last_name
      t.boolean :activate      
      t.belongs_to :company
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end