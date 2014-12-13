class SlipPtPresenter
  
  def initialize(salary_slip)
    @@professional_tax_head ||= SalaryHead.code_for_professional_tax
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
    employee.name
  end

  def tax_deduction
    @salary_slip.billed_charge_for(@@professional_tax_head).abs
  end

  def base_charge
    @salary_slip.base_charge_for_head(@@professional_tax_head).abs
  end
  
  def month_date
    @salary_sheet.formatted_run_date
  end

end
