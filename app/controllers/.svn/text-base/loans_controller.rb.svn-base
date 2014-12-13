class LoansController < CalculatorController

  before_filter :employee_loan, :only => [:edit, :update, :destroy]
  before_filter :read_financial_year, :salary_sheet_not_found, :only => [:index]
  before_filter :check_no_salary_sheet_exists, :only => [:bulk]
  
  def index
    if @employee
      @loans = EmployeeLoan.find_all_by_employee_id(@employee, :include => :effective_loan_emis)
      respond_to do |format|
        if @loans.empty?
          flash[:info] = t('loan.messages.not_exists')
          format.html{ redirect_to new_employee_loan_path(@employee) and return }
        else
          format.html{ render :template => "loans/loans" }
        end
        format.xml  { render :xml => @loans}
        format.json { render :json => @loans}
      end
    elsif @salary_sheet
      @charges = SalaryHead.charges_for_loan.on_salary_sheet(@salary_sheet).all
      render :action => 'sheet_view'
    else
      @loans = EmployeeLoan.scoped_by_company_id(@company).in_fy(@this_year).all(:include => :effective_loan_emis)
    end
  end

  def new
    @loan = EmployeeLoan.new(:employee => @employee)
    @loan.effective_loan_emis.build
  end

  def emis
    @charges = SalaryHead.charges_for_loan.on_salary_sheet(@salary_sheet).all
    if @charges.empty?
      flash[:info] = t('loan.messages.not_exists')
      redirect_to :back
    end
    respond_to do |wants|
      wants.pdf do
        @prawnto_options = {:filename=> company_file_name(:duration => @salary_sheet.formatted_run_date),
                            :page_layout=>:landscape,:page_size => "A4"}
      end
    end
  end

  def bulk
    @loans = EmployeeLoan.scoped_by_company_id(@company).in_month(@date).all
    @loans += @company.active_employees.map do |emp|
      e = EmployeeLoan.new(:company => @company,:employee => emp,:created_at => @this_month)
      e.effective_loan_emis.build
      e
    end
  end

  def bulk_create
    @date = Date.parse(params[:salary_sheet_id]).to_datetime
    @errors = EmployeeLoan.create_multi(params[:loans],@company,@date)
    if @errors.blank?
      flash[:notice] = t('loan.messages.bulk_create')
      redirect_to :action=>:index
    else
      render :action=> :bulk
    end
  end

  def create
    @loan = EmployeeLoan.new(params[:employee_loan])
    @loan.company = @company
    @loan.effective_loan_emis.each do |c|
      c.employee = @employee
      c.created_at = @loan.created_at
    end
    @loan.employee = @employee
    respond_to do |wants|
      if @loan.save
        flash[:notice] = t('loan.messages.create')
        wants.html {redirect_to  employee_loans_path(@employee)}
      else
        wants.html {render :action=>"new"}
      end
    end
  end

  def edit
    unless @loan.billed_charges.blank?
      flash[:error] = "Unable to edit this loan as there are existing billed charges against it"
      redirect_to :back
    end
  end

  def update
    @loan.attributes = params[:employee_loan]
    @loan.effective_loan_emis.each do |c|
      c.employee = @employee
      c.created_at = @loan.created_at
    end
    if @loan.save
      flash[:notice] = t('loan.messages.update')
      redirect_to  employee_loans_path(@employee)
    else
      render :action=>"edit"
    end
  end

  def destroy
    @loan.destroy
    redirect_to employee_loans_path(@employee)
  end

  #It just redirects this to existing action in salary sheet controller to just reuse the resource
  def emi_sheet
    redirect_to emi_sheet_salary_sheet_path(params[:salary_sheet])
  end

  private

  def employee_loan
    @loan = EmployeeLoan.for_employee(@employee).find(params[:id])
  end
  
  private

  def salary_sheet_not_found
    if params[:salary_sheet_id] && !@salary_sheet
      flash[:error] = "No salary sheet found for the #{params[:salary_sheet_id]}, create new?"
      redirect_to bulk_new_salary_sheet_loan_path(params[:salary_sheet_id])
    end
  end

end