class CreateCompanyHolidays < ActiveRecord::Migration
  def self.up
    create_table :company_holidays do |t|
      t.integer :company_id
      t.integer :holiday_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :company_holidays
  end
end
