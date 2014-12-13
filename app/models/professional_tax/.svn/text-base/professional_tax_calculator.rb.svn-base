class ProfessionalTaxCalculator < Calculator

  def employee_professional_tax(employee)
    EmployeeProfessionalTax.for_employee(employee).first
  end
  memoize :employee_professional_tax

  def company_professional_tax(company)
    CompanyProfessionalTax.scoped_by_company_id(company).first
  end
  memoize :company_professional_tax
  
  def gross(salary_slip)
    salary_slip.allowances.sum{|a|a.try(:amount) || 0}
  end
  memoize :gross

  def eligible_for_employee?
    pt = employee_professional_tax(employee)
    !!pt && company_professional_tax(company).eligible?(gross(salary_slip),run_date)
  end

  def calculate
    if eligible_for_employee?
      professional_tax = company_professional_tax(company)
      gross = gross(salary_slip)
      return [SalaryHead.charges_for_professional_tax.build(
          :amount => -1.0 * professional_tax.tax_amount(gross,run_date).abs,
          :base_charge => gross,
          :reference => professional_tax.slab(gross,run_date),
          :employee => employee,
          :description => professional_tax.description(gross,run_date)
        )]
    end
  end

  def employee_classes
    EmployeeProfessionalTax
  end
  
  def employee_added!(employee)
    EmployeeProfessionalTax.create!(:employee => employee,
                                    :company => employee.company)
  end
  
  def is_ready?
    unless company_professional_tax(company)
      raise CalculatorError, "Please select company professional tax"
    end
  end
end
