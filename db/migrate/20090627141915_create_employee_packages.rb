class CreateEmployeePackages < ActiveRecord::Migration
  def self.up
    create_table :employee_packages do |t|
      t.string :designation
      t.date :start_date
      t.date :end_date
      t.float :basic
      t.integer :version
      t.integer :employee_id
      t.integer :company_id

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_packages
  end
end
