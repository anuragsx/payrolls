class SheetLwfPresenter
  
  def initialize(company,sheet)
    @@employee_lwf_head ||= SalaryHead.code_for_employee_lwf
    @@employer_lwf_head ||= SalaryHead.code_for_employer_lwf
    @company = company
    @salary_sheet = sheet
    @total_employees = []
    @employer_lwf_total = 0.0
    @employee_lwf_total = 0.0
    @detail ={}
    @salary_sheet.salary_slip_charges.under_head(@@employee_lwf_head).group_by{|x| x.employee.department}.each do |department,charges|
      @detail[department] = {:name => department.name,
        :total => 0.0,
        :employees => []
      }
      charges.each do |charge|
        @employee = charge.employee
        @detail[department][:employees] << {:employee => @employee,
          :employee_name=>  @employee.name,
          :amount => charge.amount.abs}
        @detail[department][:total] += charge.amount.abs
        @total_employees <<  @employee
      end
      @employee_lwf_total += @detail[department][:total]
    end
    @employer_lwf_total += @salary_sheet.salary_slip_charges.under_head(@@employer_lwf_head).sum(:amount)
  end

  def month_date
    @salary_sheet.formatted_run_date
  end

  def total_employees
    @total_employees.uniq.size
  end
  
  def total_employer_lwf_contribution
    @employer_lwf_total.abs
  end

  def total_employee_lwf_contribution
    @employee_lwf_total.abs
  end

  def run_date
    @salary_sheet.run_date
  end
  
  def salary_sheet
    @salary_sheet
  end
  
  def depts
    @detail.values
  end
  
  
  
end
