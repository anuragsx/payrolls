class SalarySheetEsiPresenter

  attr_reader :salary_sheet
  
  def initialize(company, salary_sheet)
    @@employee_head ||= SalaryHead.code_for_employee_esi
    @@employer_head ||= SalaryHead.code_for_employer_esi
    @company = company
    @salary_sheet = salary_sheet
    @employee_total = 0
    @employer_total = 0
    @base_total = 0
    @dept_details = {}
    @esi_type = CompanyEsi.for_company(@company).first.try(:esi_type)
    employees = []
    @salary_sheet.salary_slip_charges.under_head(@@employee_head).each do |charge|
      @employee_total += charge.amount
      @base_total += charge.base_charge
      department = charge.employee.department
      @dept_details[department] ||= {:name => department.try(:name), :total_employee_contribution => 0,
                                     :total_base_charge => 0, :slips => []}
      @dept_details[department][:total_employee_contribution] += charge.amount.abs
      @dept_details[department][:total_base_charge] += charge.base_charge.abs
      @dept_details[department][:slips] += [SalarySlipEsi.new(charge.salary_slip,@@employee_head,@@employer_head)]
      employees << charge.employee
    end
    @total_employees = employees.uniq.size
    @salary_sheet.salary_slip_charges.under_head(@@employer_head).each do |charge|
      @employer_total += charge.amount
    end
  end

  def previous_month
    @salary_slip.run_date - 1.month
  end

  def next_month
    @salary_slip.run_date + 1.month
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

  def employee_contribution_percent
    "#{(@esi_type.employee_contrib_percent || 0)}%"
  end

  def employer_contribution_percent
    "#{(@esi_type.employer_contrib_percent || 0)}%"
  end

  def total_employer_contribution
    @employer_total.abs
  end

  def total_employee_contribution
    @employee_total.abs
  end

  def total_contribution
    total_employee_contribution + total_employer_contribution
  end

  def total_base_charge
    @base_total
  end

  def run_date
    @salary_sheet.run_date
  end

end
