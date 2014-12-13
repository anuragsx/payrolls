class CreateDepartmentHolidays < ActiveRecord::Migration
  def self.up
    create_table :department_holidays do |t|
      t.integer :department_id
      t.integer :holiday_id
      t.integer :company_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :department_holidays
  end
end
