class RenameExpenseClaim < ActiveRecord::Migration
  def self.up
    Calculator.update_all("type = 'ReimbursementCalculator', name = 'Reimbursement Manager'",:name => 'Expense Claim')
  end

  def self.down
  end
end
