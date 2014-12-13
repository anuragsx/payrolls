class CreateCompanyFlexiPackages < ActiveRecord::Migration
  def self.up
    create_table :company_flexi_packages do |t|
      t.integer :company_id
      t.integer :salary_head_id
      t.string :lookup_expression
      t.integer :position
      
      t.timestamps
    end
  end

  def self.down
    drop_table :company_flexi_packages
  end
end
