class CreateEmployeeDetails < ActiveRecord::Migration
  def self.up
    create_table :employee_details do |t|
      t.belongs_to :employee
      t.string :care_of
      t.date :date_of_birth
      t.boolean :sex

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_details
  end
end
