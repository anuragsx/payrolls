class SalarySlipGratuity
  def initialize(salary_slip,employee_head = nil,employer_head = nil)
    @salary_slip = salary_slip
    @employee_head = employee_head || SalaryHead.code_for_gratuity_earned
    @employer_head = employer_head || SalaryHead.code_for_gratuity_withheld
  end

  def salary_slip
    @salary_slip
  end

  def employee_name
    @salary_slip.employee.name
  end
  
  def total_employee_earned
    @salary_slip.billed_charge_for(@employee_head).abs - total_employer_withheld
  end

  def total_employer_withheld
    @salary_slip.billed_charge_for(@employer_head).abs
  end

  def total_base_charge
    (@salary_slip.salary_slip_charges.employee_id_not_nil.under_head(@employee_head).to_a.sum{|x|x.base_charge || 0}.try(:to_f).try(:round,2)) || 0
  end

end
