class CreateLabourWelfareSlabs < ActiveRecord::Migration
  def self.up
    create_table :labour_welfare_slabs do |t|
      t.integer :labour_welfare_id
      t.float :salary_min
      t.float :salary_max
      t.float :employee_contribution
      t.float :employer_contribution
      
      t.timestamps
    end
  end

  def self.down
    drop_table :labour_welfare_slabs
  end
end
