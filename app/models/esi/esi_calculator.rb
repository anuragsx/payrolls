class EsiCalculator < Calculator
  
  extend ActiveSupport::Memoizable

  def promote!(employee_package)
    company_esi(company).try(:create_for_employee,employee, employee_package.start_date)
  end

  def suspend!(employee_package)
    company_esi(company).try(:suspend_employee,employee, employee_package.end_date)
  end

  def resume!(employee_package)
    company_esi(company).try(:create_employee,employee, employee_package.start_date)
  end

  def esi(employee,run_date)
    EmployeeEsi.for_employee(employee).for_date(run_date).first
  end
  memoize :esi

  def company_esi(company)
    CompanyEsi.for_company(company).first
  end
  memoize :company_esi

  def gross(salary_slip)
    salary_slip.allowances.sum{|a|a.try(:amount) || 0}
  end
  memoize :gross

  def eligible_for_employee?
    employee_esi = esi(employee,run_date)
    company_esi = company_esi(company)
    !!employee_esi && !!company_esi && employee_esi.applicable
  end

  def calculate
    esi = esi(employee,run_date)
    company_esi = company_esi(company)
    company_esi.gross = gross(salary_slip)
    [SalaryHead.charges_for_employee_esi.build(:amount => company_esi.employee_contrib,
                                               :base_charge => company_esi.gross,
                                               :reference => esi,
                                               :description => company_esi.employee_description,
                                               :employee => employee)]
  end

  def calculate_charge_for_sheet
    company_esi = company_esi(company)
    company_esi.effective_base =  salary_sheet.charges_under_head(SalaryHead.code_for_employee_esi).sum('base_charge')
    [SalaryHead.charges_for_employer_esi.build(:amount => company_esi.employer_contrib,
                                               :base_charge => company_esi.effective_base,
                                               :reference => company_esi,
                                               :description => company_esi.employer_description)]
  end

  def company_classes
    CompanyEsi
  end

  def employee_classes
    EmployeeEsi
  end

  def is_ready?
    unless company_esi(company)
      raise CalculatorError, "Please select your comapny Esi details."
    end
  end

  def calculate_package_ctc(company, employee, emp_package)
    ctc = {}
    self.run_date = emp_package.start_date
    self.employee = employee
    self.company = company
    company_esi = company_esi(company)
    company_esi.effective_base = emp_package.employee_package_heads.map{|h| h}.sum(&:amount)
    if eligible_for_employee?
      ctc[SalaryHead.code_for_employer_esi] = company_esi.employer_contrib
    end
    ctc
  end
end