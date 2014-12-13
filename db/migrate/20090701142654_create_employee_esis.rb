class CreateEmployeeEsis < ActiveRecord::Migration
  def self.up
    create_table :employee_esis do |t|
      t.integer :employee_id
      t.integer :company_id
      t.string :esi_number
      t.boolean :applicable
      t.date :effective_date
      t.timestamps
    end
  end

  def self.down
    drop_table :employee_esis
  end
end
