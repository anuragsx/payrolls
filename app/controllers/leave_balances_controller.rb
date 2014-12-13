class LeaveBalancesController < CalculatorController

  before_filter :load_company_leave
  
  def edit
    leave_bals = EmployeeLeaveBalance.for_employee(@employee)
    @leave_balances = @company_leave.accrue_as_you_go? ? leave_bals.no_financial_year :
      (leave_bals.for_financial_year(Date.today.year - 1) + leave_bals.for_financial_year(Date.today.year) )
  end

  def bulk_update
    errors = update_leave
    if errors.blank?
      redirect_to employee_leaves_path(@employee)
    else
      @errors = errors
      render :action=> :bulk
    end
  end

  private


  def load_company_leave
    @company_leave ||= CompanyLeave.for_company(@company).last
  end
  
  def update_leave
    errors = []
    params[:leave_balance].each do |leave_balance|
      e = EmployeeLeaveBalance.find_by_id(leave_balance['id'])
      errors << e.errors.to_a unless e.update_attributes(leave_balance)
    end
    errors.uniq
  end
  
  concerned_calculators(:leave_accounting)
  
end
