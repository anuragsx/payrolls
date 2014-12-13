class SimpleIncomeTaxCalculator < Calculator
  extend ActiveSupport::Memoizable
  
  def employee_tds(run_date,employee)
    EmployeeTax.for_employee(employee).after_date(run_date).last
  end

  def eligible_for_employee?
    tds = employee_tds(run_date, employee)
    !!tds
  end

  def calculate
    if eligible_for_employee?
      effective_tax = employee_tds(run_date, employee)
      if effective_tax.amount > 0
      [SalaryHead.charges_for_tds.build(:employee => employee,
                                        :amount => -1.0 * effective_tax.amount.abs,
                                        :base_charge => effective_tax.amount,
                                        :reference => effective_tax,
                                        :description => effective_tax.description)]
      end
    end
  end

  def employee_classes
    [EmployeeTax,EmployeeTaxDetail,EmployeeInvestment80c, EmployeeOtherIncome]
  end

  def get_income_tax_pdf_content(pdf, presenter, salary_slip, cell_height)
  end
end