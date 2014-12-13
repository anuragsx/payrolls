class CreateSalarySheets < ActiveRecord::Migration
  def self.up
    create_table :salary_sheets do |t|
      t.date :run_date
      t.float :grand_total
      t.float :working_days
      t.float :holidays
      t.integer :company_id

      t.timestamps
    end
  end

  def self.down
    drop_table :salary_sheets
  end
end
