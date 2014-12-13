class RenameReimbursement < ActiveRecord::Migration
  def self.up
    rename_table(:reimbursements, :expense_claims)
    Calculator.update_all("type = 'ExpenseClaimCalculator', name = 'Expense Claim'",:type => "ReimbursementCalculator" )
    SalaryHead.update_all("name = 'Expense Claims', code = 'expense'",:code => "reimbursement")
  end

  def self.down
    rename_table(:expense_claims, :reimbursements)
  end
end
