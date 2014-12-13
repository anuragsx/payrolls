class ExpenseClaimCalculator < Calculator

  def calculate
    ExpenseClaim.for_employee(employee).expensed_in(run_date).unbilled.all.map do |claim|
      SalaryHead.charges_for_expense.build(:employee => employee,
                                                 :amount => claim.amount.abs,
                                                 :base_charge => claim.amount.abs,
                                                 :reference => claim,
                                                 :description => claim.description)
    end
  end
  
  def finalize!
    ExpenseClaim.finalize_for_slip!(run_date,salary_slip,employee)
  end

  def unfinalize!
    ExpenseClaim.unfinalize_for_slip!(salary_slip)
  end

  def employee_classes
    ExpenseClaim
  end
end
