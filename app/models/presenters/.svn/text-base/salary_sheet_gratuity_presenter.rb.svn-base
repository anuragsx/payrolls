class SalarySheetGratuityPresenter

  attr_reader :salary_sheet
  
  def initialize(company, salary_sheet)
    @@employee_earned_head ||= SalaryHead.code_for_gratuity_earned
    @@employer_withheld_head ||= SalaryHead.code_for_gratuity_withheld
    @company = company
    @salary_sheet = salary_sheet
    @employee_gratuity = 0
    @employer_gratuity_total = 0
    @base_total = 0
    @dept_details = {}
    employees = []
    @salary_sheet.salary_slip_charges.employee_id_not_nil.under_head(@@employee_earned_head).each do |charge|
      @employee_gratuity += charge.amount
      @base_total += charge.base_charge
      department = charge.employee.department
      @dept_details[department] ||= {:name => department.try(:name),
                                     :total_base_charge => 0,
                                     :total_employee_earned => 0,
                                     :total_employer_withheld => 0,
                                     :slips => []}
      @dept_details[department][:total_employee_earned] += charge.amount.abs
      @dept_details[department][:slips] += [SalarySlipGratuity.new(charge.salary_slip,
                                                             @@employee_earned_head,
                                                             @@employer_withheld_head)]
      employees << charge.employee
    end
    @salary_sheet.salary_slip_charges.employee_id_not_nil.under_head(@@employer_withheld_head).each do |charge|
      @employer_gratuity_total += charge.amount
      department = charge.employee.department
      @dept_details[department] ||= {:name => department.try(:name),
                                     :total_base_charge => 0,
                                     :total_employee_earned => 0,
                                     :total_employer_withheld => 0,
                                     :slips => []}
      @dept_details[department][:total_employer_withheld] += charge.amount.abs
    end
    @total_employees = employees.uniq.size
  end

  def previous_month
    @salary_sheet.run_date.last_month
  end

  def next_month
    @salary_sheet.run_date.next_month
  end

  def slips
    departments.map{|x|x[:slips]}.flatten
  end

  def total_employees
    @total_employees
  end

  def departments
    @dept_details.values
  end

  def month_date
    @salary_sheet.formatted_run_date
  end

  def short_date
    @salary_sheet.formatted_run_date
  end

  def total_employee_earned
    employee_earned
  end
  
  def total_employer_withheld
    employer_withheld
  end

  def employee_earned
    @employee_gratuity.abs
  end

  def employer_withheld
    @employer_gratuity_total.abs
  end
  
  def total_base_charge
    @base_total
  end

  def run_date
    @salary_sheet.run_date
  end

end
