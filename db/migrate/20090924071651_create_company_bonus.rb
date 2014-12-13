class CreateCompanyBonus < ActiveRecord::Migration
  def self.up
    create_table :company_bonus do |t|
      t.belongs_to :company
      t.float :bonus_percent
      t.date :release_date

      t.timestamps
    end
  end

  def self.down
    drop_table :company_bonus
  end
end
