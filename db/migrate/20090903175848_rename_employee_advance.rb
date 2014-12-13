class RenameEmployeeAdvance < ActiveRecord::Migration
  def self.up
    Calculator.update_all("type = 'AdvanceCalculator'",:name => 'Employee Advances')
  end

  def self.down
  end
end
