# To change this template, choose Tools | Templates
# and open the template in the editor.
class SimpleLeaveCalculator < Calculator

  WORKING_HOURS = 8

  def days_in_month(run_date)
    month_days = Time.days_in_month(run_date.month,run_date.year)
  end
  
  def leave_ratio
    holidays = 0
    leave = EmployeeLeave.for_employee(employee).for_month(run_date).first
    leave.update_unpaid! if leave
    month_days = days_in_month(run_date)
    [(applicable_days - total_leaves)/month_days, total_leaves]
  end

  def applicable_days
    EmployeeLeave.applicable_days(employee, run_date)
  end

  def total_leaves
    leave = EmployeeLeave.for_employee(employee).for_month(run_date).first
    leave ? leave.total_leaves : 0.0
  end

  def finalize!
    EmployeeLeave.finalize_for_slip!(run_date,salary_slip)
  end

  def unfinalize!
    EmployeeLeave.unfinalize_for_slip!(salary_slip)
  end

  def employee_classes
    EmployeeLeave
  end
end