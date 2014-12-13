class SalarySheetPfPresenter

  attr_reader :salary_sheet, :pension_admin, :pension_edli, :pension_inspection
  
  def initialize(company, salary_sheet)
    @@employee_head ||= SalaryHead.code_for_employee_pf
    @@employee_vpf_head ||= SalaryHead.code_for_employee_vpf
    @@employer_pf_head ||= SalaryHead.code_for_employer_pf
    @@employer_epf_head ||= SalaryHead.code_for_employer_epf
    @@admin_charge_head ||= SalaryHead.code_for_employer_pf_admin
    @@edli_charge_head ||= SalaryHead.code_for_employer_pf_edli
    @@inspection_charge_head ||= SalaryHead.code_for_employer_pf_inspection
    @company = company
    @salary_sheet = salary_sheet
    @employee_pf = 0
    @employee_vpf_total = 0
    @employer_pf_total = 0
    @employer_epf_total = 0
    @base_total = 0
    @dept_details = {}
    employees = []
    @salary_sheet.salary_slip_charges.under_head(@@employee_head).each do |charge|
      @employee_pf += charge.amount
      @base_total += charge.base_charge
      department = charge.employee.department
      @dept_details[department] ||= {:name => department.try(:name),
                                     :employee_contribution => 0,
                                     :total_employee_contribution => 0,
                                     :total_contribution => 0,
                                     :total_employer_epf_contribution => 0,
                                     :total_employer_pf_contribution => 0,
                                     :total_employer_vpf_contribution => 0,
                                     :total_employee_vpf_contribution => 0,
                                     :total_employer_contribution => 0,
                                     :total_base_charge => 0,
                                     :slips => []}
      @dept_details[department][:employee_contribution] += charge.amount.abs
      @dept_details[department][:total_employee_contribution] += charge.amount.abs
      @dept_details[department][:total_base_charge] += charge.base_charge.abs
      @dept_details[department][:total_contribution] += charge.amount.abs
      @dept_details[department][:slips] += [SalarySlipPf.new(charge.salary_slip,
                                                             @@employee_head,
                                                             @@employer_epf_head,
                                                             @@employer_pf_head)]
      employees << charge.employee
    end
    @total_employees = employees.uniq.size
    @salary_sheet.salary_slip_charges.under_head(@@employer_pf_head).each do |charge|
      @employer_pf_total += charge.amount
      department = charge.salary_slip.employee.department
      @dept_details[department][:total_employer_pf_contribution] += charge.amount.abs
      @dept_details[department][:total_employer_contribution] += charge.amount.abs
      @dept_details[department][:total_contribution] += charge.amount.abs
    end
    @salary_sheet.salary_slip_charges.under_head(@@employer_epf_head).each do |charge|
      @employer_epf_total += charge.amount
      department = charge.salary_slip.employee.department
      @dept_details[department][:total_employer_epf_contribution] += charge.amount.abs
      @dept_details[department][:total_employer_contribution] += charge.amount.abs
      @dept_details[department][:total_contribution] += charge.amount.abs
    end
    @salary_sheet.salary_slip_charges.under_head(@@employee_vpf_head).each do |charge|
      @employee_vpf_total += charge.amount
      department = charge.salary_slip.employee.department
      @dept_details[department][:total_employee_vpf_contribution] += charge.amount.abs
      @dept_details[department][:total_employee_contribution] += charge.amount.abs
      @dept_details[department][:total_contribution] += charge.amount.abs
    end
    @pension_admin = @salary_sheet.total_contribution(@@admin_charge_head)
    @pension_edli = @salary_sheet.total_contribution(@@edli_charge_head)
    @pension_inspection = @salary_sheet.total_contribution(@@inspection_charge_head)
  end

  def other_pf_charges
    @pension_admin + @pension_edli + @pension_inspection
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

  def total_employer_pf_contribution
    @employer_pf_total.abs
  end

  def total_employer_epf_contribution
    @employer_epf_total.abs
  end

  def total_employee_contribution
    employee_contribution + employee_vpf_contribution
  end

  def employee_contribution
    @employee_pf.abs
  end

  def employee_vpf_contribution
    @employee_vpf_total.abs
  end

  def total_employer_contribution
    total_employer_pf_contribution + total_employer_epf_contribution
  end

  def total_contribution
    total_employee_contribution + total_employer_pf_contribution +
      total_employer_epf_contribution + other_pf_charges
  end

  def total_base_charge
    @base_total
  end

  def run_date
    @salary_sheet.run_date
  end

end
