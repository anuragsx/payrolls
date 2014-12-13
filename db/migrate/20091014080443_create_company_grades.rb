class CreateCompanyGrades < ActiveRecord::Migration
  def self.up
    create_table :company_grades do |t|
      t.string :name
      t.integer :company_id
      t.string :pay_scale
      t.timestamps
    end
  end

  def self.down
    drop_table :company_grades
  end
end
