class CreateEmployeePackageHeads < ActiveRecord::Migration
  def self.up
    create_table :employee_package_heads do |t|
      t.integer :employee_id
      t.integer :employee_package_id
      t.integer :salary_head_id
      t.integer :company_id
      t.float :amount
      t.boolean :leave_dependent

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_package_heads
  end
end
