class AddSingleAccessTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :single_access_token, :string, :null => false
  end
end
