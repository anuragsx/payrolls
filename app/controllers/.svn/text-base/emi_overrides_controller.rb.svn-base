class EmiOverridesController < CalculatorController

  before_filter :load_loan
  
  def new
    @emi_override = @loan.effective_loan_emis.build()
  end

  def create
    @emi_override = @loan.effective_loan_emis.build(params[:effective_loan_emi])
    @emi_override.employee = @employee

    if @emi_override.save
      flash[:notice] = t('loan.messages.emis.overridden')
      redirect_to employee_loans_path(@employee)
    else
      render :action=>"new"
    end
  end

  def edit
    @emi_override = @loan.effective_loan_emis.find(params[:id])
    if @company.salary_sheets.salary_sheet_for(@emi_override.created_at.to_date).blank?
      render
    else
      flash[:notice] = t('loan.messages.emis.paid')
      redirect_to employee_loans_path(@employee)
    end
  end

  def update
    @emi_override = @loan.effective_loan_emis.find(params[:id])
    if @emi_override.update_attributes(params[:effective_loan_emi])
      flash[:notice] = t('loan.messages.emis.update')
      redirect_to employee_loans_path(@employee)
    else
      render :action=>"edit"
    end
  end

  def destroy
    @emi_override = @loan.effective_loan_emis.find(params[:id])
    @emi_override.destroy
    redirect_to employee_loans_path(@employee)
  end

  private
  def load_loan
    @loan ||= EmployeeLoan.find(params[:loan_id])
  end

  concerned_calculators(:loan)

end