class CreateCompanyLoadings < ActiveRecord::Migration
  def self.up
    create_table :company_loadings do |t|
      t.integer :company_id
      t.float :loading_percent
      t.timestamps
    end
  end

  def self.down
    drop_table :company_loadings
  end
end
