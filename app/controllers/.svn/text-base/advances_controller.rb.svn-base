class AdvancesController < CalculatorController

  before_filter :load_advance, :only => [:edit, :update, :destroy]
  before_filter :read_financial_year, :salary_sheet_not_found, :only => [:index]
  before_filter :group_salary_sheets, :only => [:index]

  def index
    unless @salary_sheet
      @advances = EmployeeAdvance.search(@company,@employee,@this_year)
      if @advances.empty?
        flash[:info] = t('advance.messages.no_advance')
        redirect_to(new_employee_advance_path(@employee)) and return if @employee
      end
    else
      @charges = SalaryHead.charges_for_advance.on_salary_sheet(@salary_sheet).all
      render :action => 'sheet_view'
    end
  end

  def bulk  
    @date = Date.parse(params[:salary_sheet_id]|| Date.today.to_s).try(:beginning_of_month) 
    @next_month = @date + 1.month
    @prev_month = @date - 1.month
    @advances = EmployeeAdvance.for_company(@company).in_year(@date.year).find_by_months(@date.month)
    @new_advances = @company.active_employees.map do |emp|
      EmployeeAdvance.new(:company => @company,:employee => emp,:created_at => @date)
    end
  end

  def bulk_create
    @date = Date.parse(params[:date]).to_datetime
    @errors = EmployeeAdvance.create_multi(params[:advances],@company,@date)
    if @errors.blank?
      flash[:notice] = t('advance.messages.bulk_create')
      redirect_to :action => :index
    else
      @next_month = @date + 1.month
      @prev_month = @date - 1.month
      render :action => :bulk
    end
  end

  def new
    @advance = EmployeeAdvance.new(:created_at => Date.today)
    @advance.employee = @employee
    @advance.company = @company
  end

  def create
    @advance = EmployeeAdvance.new(params[:employee_advance])
    @advance.employee = @employee
    @advance.company = @company
    if @advance.save
      flash[:notice] = t('advance.messages.create')
      redirect_to employee_advances_path(@employee)
    else
      flash[:error] = t('advance.messages.error_saving')
      render :action=> :new
    end
  end

  def update
    if @advance.update_attributes(params[:employee_advance])
      flash[:notice] = t('advance.messages.update')
      redirect_to employee_advances_path(@employee)
    else
      flash[:error] = t('advance.messages.error_updating')
      render :action=>:edit
    end
  end

  def destroy
    unless @advance.billed?
      @advance.destroy
      flash[:notice] = t('advance.messages.destroy')
    else
      flash[:error] = t('advance.messages.billed')
    end
    redirect_to employee_advances_path(@employee)
  end

  private

  def load_advance
    @advance = EmployeeAdvance.scoped_by_company_id(@company).find(params[:id])
  end

  def salary_sheet_not_found
    if params[:salary_sheet_id] && !@salary_sheet
      flash[:error] = "No salary sheet found for the #{params[:salary_sheet_id]}, create new?"
      redirect_to bulk_new_salary_sheet_advance_path(params[:salary_sheet_id])
    end
  end

end