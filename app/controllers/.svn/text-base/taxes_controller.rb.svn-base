class TaxesController < ApplicationController

  before_filter :load_employee_tax, :only => [:edit,:update]

  def index
    @employee_taxes = EmployeeTax.for_employee(@employee)
    flash[:notice] = t('tax.messages.tax.set_amount'); redirect_to :action => :new if @employee_taxes.blank?
  end

  def new
    @employee_tax = EmployeeTax.new()
  end

  def create
    @employee_tax = EmployeeTax.new(params[:employee_tax])
    @employee_tax.employee = @employee
    @employee_tax.company = @company
    if @employee_tax.save
      flash[:notice] = t('tax.messages.tax.created')
      redirect_to :action=>:index
    else
      render :action=>:new
    end
  end

  def update
    if @employee_tax.update_attributes(params[:employee_tax])
      flash[:notice] = t('tax.messages.tax.updated')
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  private
  
  def load_employee_tax
    @employee_tax = EmployeeTax.find(params[:id]) if params[:id]
  end

end
