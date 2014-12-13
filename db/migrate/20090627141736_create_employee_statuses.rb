class CreateEmployeeStatuses < ActiveRecord::Migration
  def self.up
    create_table :employee_statuses do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_statuses
  end
end
