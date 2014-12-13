class LeaveAccountingCalculator < Calculator

  def employee_added!(employee)
    EmployeeLeaveBalance.employee_added!(employee)
  end

  def company_info(company)
    CompanyLeave.for_company(company).first
  end
  
  def leave_ratio
    company_info = company_info(company)
    return EmployeeLeave.determine_leave_ratio(company_info,salary_slip)
    # present_days = get present days from EmployeeLeave table
    # absence_days = get absense days from EmployeeLeave table
    # update_earned_leaves(present_days)
    # (paid_leaves,unpaid_leaves) = consume_earned_leaves(absence_days)
    # leaves = unpaid_leaves
    # leave_ratio = (present_days + paid_leaves + holidays) / month_days
  end

  def finalize!
    EmployeeLeave.finalize_for_slip!(run_date,salary_slip)
  end

  def unfinalize!
    company_info = company_info(company)
    EmployeeLeave.degrade_leave!(company_info,salary_slip)
    EmployeeLeave.unfinalize_for_slip!(salary_slip)
  end

  def company_classes
    CompanyLeave
  end

  def employee_classes
    [EmployeeLeaveBalance,EmployeeLeave]
  end

  def is_ready?
    unless company_info(company)
      raise CalculatorError, "Please select your comapny leave details."
    end
  end

  def bulk_create_leave_balance   
    employees = company.employees.all(:conditions => ['employees.status= ?',"active"])
    employees.each do |e|     
      exist_employee = EmployeeLeaveBalance.for_employee(e)
      EmployeeLeaveBalance.employee_added!(e) if exist_employee.blank?
    end
  end
end
