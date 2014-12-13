class LoanCalculator < Calculator

  extend ActiveSupport::Memoizable
  
  def active_loans(employee,run_date)
    EmployeeLoan.active_loans_for_employee(employee,run_date)
  end
  memoize :active_loans
  
  def eligible_for_employee?
    loans = active_loans(employee,run_date)
    !loans.empty?
  end

  def calculate
    loans = active_loans(employee,run_date)
    loans.map do |loan|
      loan.run_date = run_date
      effective_deduction = loan.effective_deduction.abs
      SalaryHead.charges_for_loan.build(:employee => employee,
                                        :reference => loan,
                                        :description => loan.description,
                                        :base_charge => loan.total_remaining,
                                        :amount => -1.0 * effective_deduction)
    end
  end

  def employee_classes
    EmployeeLoan
  end

end
