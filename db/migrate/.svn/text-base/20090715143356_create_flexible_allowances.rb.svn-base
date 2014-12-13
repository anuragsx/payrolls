class CreateFlexibleAllowances < ActiveRecord::Migration
  def self.up
    create_table :flexible_allowances do |t|
      t.string :category_type
      t.integer :category_id
      t.integer :company_id
      t.integer :salary_head_id
      t.float :value
      t.string :head_type
      t.boolean :leave_dependent
      t.integer :company_flexi_package_id
      t.timestamps
    end
  end

  def self.down
    drop_table :flexible_allowances
  end
end
