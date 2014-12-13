class CreateCompanyAllowanceHeads < ActiveRecord::Migration
  def self.up
    create_table :company_allowance_heads do |t|
      t.integer :company_id
      t.integer :salary_head_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :company_allowance_heads
  end
end
