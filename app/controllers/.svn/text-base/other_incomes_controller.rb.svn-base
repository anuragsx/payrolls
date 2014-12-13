class OtherIncomesController < ApplicationController

  def index
    @other_incomes = EmployeeOtherIncome.for_employee(@employee).group_by{|i| i.financial_year}
    flash[:notice] = t('tax.messages.other_income.set')
    redirect_to :action => :new if @other_incomes.blank?
  end

  def new
    @other_income = EmployeeOtherIncome.new()
  end

  def edit
    @other_income = EmployeeOtherIncome.find(params[:id])
    if @other_income.is_billed?
      flash[:error] = "Unable to edit this other inocme as there are existing billed charges against it"
      redirect_to :back
    end
  end

  def create
    @other_income = EmployeeOtherIncome.new(params[:employee_other_income])
    @other_income.company = @company
    @other_income.employee = @employee
    if @other_income.save
      flash[:notice] = t('tax.messages.other_income.create')
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def update
    @other_income = EmployeeOtherIncome.find(params[:id])
    if @other_income.update_attributes(params[:employee_other_income])
      flash[:notice] = t('tax.messages.other_income.update')
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @other_income = EmployeeOtherIncome.find(params[:id])
    if @other_income.is_billed?
      flash[:error] = "Unable to destroy this other inocme as there are existing billed charges against it"
      redirect_to :back
    else
      @other_income.destroy
    end
  end
  
end
