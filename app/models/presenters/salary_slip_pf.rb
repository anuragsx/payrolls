class SalarySlipPf
  def initialize(salary_slip,employee_head=nil,employer_epf_head=nil, employer_pf_head=nil, employee_vpf_head = nil,employer_vpf_head = nil)
    @salary_slip = salary_slip
    @employee_head = employee_head || SalaryHead.code_for_employee_pf
    @employer_pf_head = employer_pf_head || SalaryHead.code_for_employer_pf
    @employer_epf_head = employer_epf_head || SalaryHead.code_for_employer_epf
    @employee_vpf_head = employee_vpf_head || SalaryHead.code_for_employee_vpf
  end

  def salary_slip
    @salary_slip
  end

  def employee
    @salary_slip.employee
  end
  
  def employee_name
    @salary_slip.employee.name
  end
  
  def total_contribution
    total_employee_contribution + total_employer_contribution
  end

  def employee_contribution
    @salary_slip.billed_charge_for(@employee_head).abs
  end

  def employee_vpf_contribution
    (@salary_slip.billed_charge_for(@employee_vpf_head) || 0).abs
  end

  def total_employee_contribution
    employee_contribution + employee_vpf_contribution
  end

  def total_employer_pf_contribution
    @salary_slip.billed_charge_for(@employer_pf_head).abs
  end

  def total_employer_epf_contribution
    @salary_slip.billed_charge_for(@employer_epf_head).abs
  end

  def total_employer_contribution
    total_employer_epf_contribution + total_employer_pf_contribution
  end

  def total_base_charge
    (@salary_slip.salary_slip_charges.under_head(@employee_head).to_a.sum{|x|x.base_charge || 0}.try(:to_f).try(:round,2)) || 0
  end

end
