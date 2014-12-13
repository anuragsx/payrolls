class PfCalculator < Calculator
  extend ActiveSupport::Memoizable

  def employee_pf(employee,run_date)
    EmployeePension.eligible(run_date).for_employee(employee).for_date(run_date).last
  end
  memoize :employee_pf

  def company_pf(company)
    CompanyPf.scoped_by_company_id(company).first
  end
  memoize :company_pf

  def eligible_for_employee?
    !!employee_pf(employee,run_date)
  end

  def calculate
    employee_pf = employee_pf(employee,run_date)
    employee_pf.basic = salary_slip.charge_for(SalaryHead.code_for_basic)
    employee_pf.da = salary_slip.charge_for(SalaryHead.code_for_da)
    employee_pf.dr = salary_slip.charge_for(SalaryHead.code_for_dearness_relief)
    charges = employee_pf.statutory_charges.map do |charge|
      SalarySlipCharge.new(charge)
    end
    charges
  end

  def calculate_charge_for_sheet
    company_pf = company_pf(company)
    company_pf.effective_base = salary_sheet.charges_under_head(SalaryHead.code_for_employee_pf).sum('base_charge')
    charges = company_pf.company_charges.map do |charge|
      SalarySlipCharge.new(charge)
    end
    charges
  end
  
  def company_classes
    CompanyPf
  end

  def employee_classes
    EmployeePension
  end

  def is_ready?
    unless company_pf(company)
      raise CalculatorError, "#{I18n.t('exceptions.calculator.pf')}"
    end
  end

  def calculate_package_ctc(company, employee, emp_package)
    ctc = {}
    run_date = emp_package.start_date
    employee_pf = employee_pf(employee,run_date)
    if employee_pf
      employee_pf.basic = emp_package.basic || 0
      employee_pf.da = emp_package.employee_package_heads.find_by_salary_head_id(SalaryHead.code_for_da).try(:amount) || 0
      employee_pf.dr = emp_package.employee_package_heads.find_by_salary_head_id(SalaryHead.code_for_dr).try(:amount) || 0
      employee_pf.try(:statutory_charges).each do |charge|
        ctc[charge[:salary_head]] = charge[:amount] if charge[:amount] > 0
      end
    end
    ctc
  end

end