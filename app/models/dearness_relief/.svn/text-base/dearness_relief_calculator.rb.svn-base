class DearnessReliefCalculator < Calculator

  extend ActiveSupport::Memoizable

  def loading(company,run_date)
    CompanyLoading.for_company(company).effective_for_date(run_date).first
  end
  memoize :loading

  def eligible_for_employee?
    !!loading(company,run_date)
  end

  def calculate
    loading = loading(company,run_date)
    loading_percent = loading.loading_percent.abs
    # Find the allowances to add
    allowances = (salary_slip.charge_for(SalaryHead.code_for_basic) + salary_slip.charge_for(SalaryHead.code_for_da)).round(2).abs
    # Find the amount to load
    [SalaryHead.charges_for_dearness_relief.build(
      :employee => employee,
      :base_charge => allowances,
      :reference => loading,
      :description => "Relief of #{loading_percent}% on #{allowances}",
      :amount => (allowances * loading_percent / 100.0).round)]
  end

  def company_classes
    CompanyLoading
  end

end