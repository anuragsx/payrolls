class SlipLwfPresenter
  
  def initialize(salary_slip)
    @@employee_lwf_head ||= SalaryHead.code_for_employee_lwf
    @@employer_lwf_head ||= SalaryHead.code_for_employer_lwf
    @salary_slip = salary_slip
    @salary_sheet = @salary_slip.salary_sheet
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

  def employee_lwf_contribution
    @salary_slip.billed_charge_for(@@employee_lwf_head).abs
  end

  def employer_lwf_contribution
    @salary_slip.billed_charge_for(@@employer_lwf_head).abs
  end
  
  def month_date
    @salary_sheet.formatted_run_date
  end

end
