class UndergroundTaxFormula < TaxFormula

  THRESHOLD = 800
  def employee_tds
    EmployeeTaxDetail.for_employee(employee).last
  end

  def eligible_for_employee?
    !!employee_tds
  end

  def calculate
    if eligible_for_employee?
      return amount - [amount,THRESHOLD].min
    end
    amount
  end
end