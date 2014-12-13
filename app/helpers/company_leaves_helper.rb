module CompanyLeavesHelper
  def show_leave_accrual(company_leave = @company_leave)
    company_leave.accrue_as_you_go? ? "Accrue as you go" : "Earn now consume next year"
  end
end