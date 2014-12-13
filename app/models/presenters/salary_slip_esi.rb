class SalarySlipEsi
  def initialize(salary_slip,employee_head = nil,employer_head = nil)
    @salary_slip = salary_slip
    @employee_head = employee_head || SalaryHead.code_for_employee_esi
    @employer_head = employer_head || SalaryHead.code_for_employer_esi
  end

  def salary_slip
    @salary_slip
  end

  def employee_name
    @salary_slip.employee.name
  end
  
  def total_contribution
    total_employee_contribution + total_employer_contribution
  end

  def total_employee_contribution
    @salary_slip.billed_charge_for(@employee_head).abs
  end

  def total_employer_contribution
    @salary_slip.billed_charge_for(@employer_head).abs
  end

  def total_base_charge
    (@salary_slip.salary_slip_charges.under_head(@employee_head).to_a.sum{|x|x.base_charge || 0}.try(:to_f).try(:round,2)) || 0
  end

end
