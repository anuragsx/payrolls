class ExpenseClaimsController < CalculatorController

  before_filter :read_financial_year, :only => [:index]
  before_filter :group_salary_sheets, :only => [:index]
  before_filter :check_no_salary_sheet_exists, :only => [:bulk]
  before_filter :salary_sheet_not_found, :only => [:index]
  
  def index
    respond_to do |format|
      unless @salary_sheet
        @expenses = ExpenseClaim.search(@company,@this_year,@employee)
        if @expenses.empty?
          flash[:info] = t('expense.messages.not_exists')
          if @employee
            format.html do
              redirect_to(new_employee_expense_claim_path(@employee)) and return
            end
          end
          format.xml  { render :xml => @expenses }
          format.json { render :json => @expenses }
        end
        format.html
        format.pdf do
          @prawnto_options = {:filename=> company_file_name(:action => 'register')}
        end
        format.xml  { render :xml => @expenses.values.flatten! }
        format.json { render :json => @expenses.values.flatten! }
      else
        @charges = SalaryHead.charges_for_expense.on_salary_sheet(@salary_sheet).all
        format.html { render :action => 'sheet_view' }
      end
    end
  end

  def detailed_info
    @search_date = Date.parse(params[:search_date])
    @expenses = ExpenseClaim.detail_search(@company,params,@search_date)
    respond_to do |format|
      format.js
    end
  end
  
  def show
    @expens = ExpenseClaim.find(params[:id])
  end

  def bulk
    @prev_month = @date - 1.month
    @next_month = @date + 1.month
    @expenses = ExpenseClaim.for_company(@company).expensed_in(@date)
    @new_expenses = @company.employees.map do |emp|
      ExpenseClaim.new(:company => @company,:employee => emp,:expensed_at => @this_month)
    end
  end

  def bulk_create
    @date = Date.parse(params[:date]).to_datetime
    @errors = ExpenseClaim.create_multi(params[:expenses],@company,@date)
    if @errors.blank?
      flash[:notice] = t('expense.messages.create')
      redirect_to :action=>:index
    else
      @prev_month = @date - 1.month
      @next_month = @date + 1.month
      render :action=> :bulk
    end
  end
  
  def new
    @expense = ExpenseClaim.new(:employee => @employee)
  end
  
  def create
    @expense = ExpenseClaim.new(params[:expense_claim])
    @expense.employee = @employee
    @expense.company = @company
    if @expense.save
      flash[:notice] = t('expense.messages.create')
      redirect_to employee_expense_claims_path(@employee)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @expense = ExpenseClaim.find(params[:id])
  end
  
  def update
    @expense = ExpenseClaim.find(params[:id])
    if @expense.update_attributes(params[:expense_claim])
      flash[:notice] = t('expense.messages.update')
      redirect_to employee_expense_claims_path(@employee)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @expense = ExpenseClaim.find(params[:id])
    unless @expense.billed?
      @expense.destroy
      flash[:notice] = t('expense.messages.destroy')
    else
      flash[:error] = t('expense.messages.billed')
    end
    redirect_to employee_expense_claims_path(@employee)
  end

  private 
  
  def salary_sheet_not_found
    if params[:salary_sheet_id] && !@salary_sheet
      flash[:error] = "No salary sheet found for the #{params[:salary_sheet_id]}, create new?"
      redirect_to bulk_new_salary_sheet_expense_claim_path(params[:salary_sheet_id])
    end
  end

end