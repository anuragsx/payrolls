class CompanyCalculatorsController < ApplicationController

  def index
    @leave_calculators = Calculator.by_leave
    @package_calculator = Calculator.by_package
    @allowance_calculators = Calculator.by_allowance
    @income_tax_calculator = Calculator.type_equals(['SimpleIncomeTaxCalculator','IncomeTaxCalculator', 'AnnuallyEquatedTaxCalculator'])
    @deduction_calculators = Calculator.by_deduction -  @income_tax_calculator
    @bonus_calculators = Calculator.by_subtotal
    @addon_calculators = Calculator.by_addon
  end

  def update    
    calculators = params[:calculator][:list]
    if calculators
      @company.company_calculators.each{|calc| calc.delete}
      @errors = CompanyCalculator.bulk_create(calculators,@company)
      flash[:notice] = t('calculator.messages.create')
    end
    redirect_to company_calculators_path
  end
  
end