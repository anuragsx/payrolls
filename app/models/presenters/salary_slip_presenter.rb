class SalarySlipPresenter
  extend ActiveSupport::Memoizable
  include ActionView::Helpers::NumberHelper
  
  attr_reader :salary_sheet,:employee,:company

  def initialize(slip)
    @slip = slip
    @company = slip.company
    @salary_sheet = slip.salary_sheet
    @employee = slip.employee
  end
  
  def allowances
    @allowances ||= @slip.allowance_charges.positionally
  end
  
  def deductions
    @deductions ||= @slip.deduction_charges.positionally
  end
  
  def total_deduction
    (deductions.sum('amount').abs || 0.0).round(2)
  end
  memoize :total_deduction

  def gross
    (allowances.sum('amount')|| 0.0).round(2)
  end
  memoize :gross

  def net
    gross - total_deduction || 0.0
  end

  def basic
    @employee.effective_basic(@salary_sheet.run_date)
  end
  memoize :basic

  def leave_ratio
    @slip.leave_ratio.round(4)
  end
  
  def total_leaves
    @slip.leaves.round(2) || 0
  end

  def lop
    employee_leave.employee_leave_types.sum('unpaid') || 0 if employee_leave
  end
  
  def employee_name
    @employee.employee_name
  end

  def employee_detail
    { :name => @employee.employee_name,
      :pan_no => EmployeeTaxDetail.pan_for_employee(@employee),
      :pf_ac_no => EmployeePension.epf_for_employee(@employee),
      :designation => @employee.effective_package(@salary_sheet.run_date).try(:designation),
      :ac_no => @employee.account_number
    }
  end
  memoize :employee_detail

  def month_date
    @salary_sheet.formatted_run_date
  end
  
  def tds
    IncomeTaxPresenter.new(@slip)
  end
  memoize :tds

  def department
    @employee.department_name
  end
  
  def attendance_detail
    dept_details = ActiveSupport::OrderedHash.new
    if employee_leave
      dept_details[:present] = employee_leave.try(:present)
      dept_details[:paid] = employee_leave.employee_leave_types.sum('paid')
      dept_details["L.O.P."] = employee_leave.employee_leave_types.sum('unpaid') + 
                                (company.has_calculator?(LeaveAccountingCalculator) ? (employee_leave.absent || 0.0) : 0.0)
      dept_details[:holidays] = employee_leave.try(:holidays)
      dept_details[:late_hours] = employee_leave.late_hours 
      dept_details[:overtime_hours] = employee_leave.overtime_hours
      dept_details[:extra_work_days] = employee_leave.try(:extra_work_days)
      dept_details[:total_days] = employee_leave.try(:days_in_month) + (employee_leave.try(:extra_work_days) || 0)
      dept_details.delete_if {|key, value| value == nil }
    end
    dept_details
  end
  memoize :attendance_detail
  
  def leave_detail
    leave_detail= []
    if company_leave && company_leave.accrue_as_you_go?
      elbs = EmployeeLeaveBalance.for_employee(@employee).no_financial_year
      unless elbs.blank?
        elbs.map {|elb| leave_detail << accrue_as_you_go(elb)}
      end
    elsif company_leave && !company_leave.accrue_as_you_go?
      elbs = EmployeeLeaveBalance.for_employee(@employee).for_financial_year(@salary_sheet.financial_year)
      unless elbs.blank?
        elbs.map {|elb| leave_detail << not_accrue_as_you_go(elb)}
      end
    end
    leave_detail
  end
  memoize :leave_detail
  
  def accrue_as_you_go(eb)
    leave_detail= ActiveSupport::OrderedHash.new
    leave_detail[:type] = eb.leave_type
    leave_detail[:leave_earned]= eb.earned_leaves
    leave_detail[:leave_spent]= eb.spent_leaves
    leave_detail[:leave_available]= eb.current_balance
    leave_detail.delete_if {|key, value| value == nil }
    leave_detail
  end
  
  def not_accrue_as_you_go(eb)
    leave_detail= ActiveSupport::OrderedHash.new
    leave_detail[:type] = eb.leave_type
    leave_detail[:opening_balance]= eb.current_balance
    leave_detail[:consume]= eb.spent_leaves
    leave_detail[:left]=  eb.current_balance
    #    leave_detail["leave earned in #{@salary_sheet.formatted_run_date}"]= employee_leave.privilege_leave.try(:earning)
    #    leave_detail["leave earned upto #{@salary_sheet.formatted_run_date}"]= eb.earned_leaves - (employee_leave.privilege_leave.try(:earning) ||0.0 )
    leave_detail["Earned (Next_Year)"] = number_with_precision(eb.earned_leaves.round(2), :precision => 2)
    leave_detail.delete_if {|key, value| value == nil }
    leave_detail
  end

  def gross_base_charge
    allowances.sum('base_charge').round(2)
  end

  private

  def employee_leave
    EmployeeLeave.for_salary_slip(@slip).last
  end
  memoize :employee_leave
  
  def company_leave
    CompanyLeave.for_company(@company).last
  end
  memoize :company_leave

end