class InvestmentsController < ApplicationController

  def index
    @investments = EmployeeInvestment80c.for_employee(@employee).group_by{|i| i.financial_year}
    if @investments.blank?
      flash[:notice] = t('tax.messages.investment.set')
      redirect_to :action => :new
    end
  end

  def new
    @investment = EmployeeInvestment80c.new()
  end
  
  def edit
    @investment = EmployeeInvestment80c.find(params[:id])
  end

  def create
    @investment = EmployeeInvestment80c.new(params[:employee_investment80c])
    @investment.company = @company
    @investment.employee = @employee
    if @investment.save
      flash[:notice] = t('tax.messages.investment.create')
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def update
    @investment = EmployeeInvestment80c.find(params[:id])
    if @investment.update_attributes(params[:employee_investment80c])
      flash[:notice] = t('tax.messages.investment.update')
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end
  
  def destroy
    @investment = EmployeeInvestment80c.find(params[:id])
    if @investment.destroy
      flash[:notice] = t('tax.messages.investment.destroy')
    end
    redirect_to employee_investments_path(@employee)
  end

end
