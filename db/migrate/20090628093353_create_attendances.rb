class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :employee_id
      t.integer :company_id
      t.integer :attendance_type_id
      t.datetime :attendance_date
      t.datetime :timein
      t.datetime :timeout
      t.string :entered_by
      t.string :approved_by
      t.integer :approval_status_id
      t.timestamps
    end
  end

  def self.down
    drop_table :attendances
  end
end
