class InsurancesController < CalculatorController

  before_filter :load_insurance, :except => [:index, :new, :create, :premium, :bulk, :bulk_create]
  before_filter :read_financial_year, :only => [:index]
  before_filter :check_if_salary_sheet_exists, :only => [:bulk]
  before_filter :current_sheet, :only => [:premium,:index]

  def index
    respond_to do |format|
      if @employee
        @insurances = EmployeeInsurancePolicy.for_company(@company).for_employee(@employee).all
        if @insurances.empty?
          flash[:info] = t('insurance.messages.not_exists')
          format.html {redirect_to new_employee_insurance_path(@employee) and return }
        end
        format.html
        format.xml  { render :xml => @insurances}
        format.json { render :json => @insurances}
      elsif @salary_sheet
        @charges = SalaryHead.charges_for_insurance.on_salary_sheet(@salary_sheet).all
        format.html {render :action => 'sheet_view'}
      else
        @insurances = EmployeeInsurancePolicy.for_company(@company).all
        format.html do
          render :template=> "insurances/list_insurance"
        end
        format.pdf do
          @prawnto_options = {:filename => company_file_name(:action => 'register')}
        end
      end      
    end
  end

  def premium
    @charges = SalaryHead.charges_for_insurance.on_salary_sheet(@salary_sheet).billed.all
    respond_to do |wants|
      wants.pdf do
        @prawnto_options = {:filename=> company_file_name(:duration => @salary_sheet.formatted_run_date),
          :page_layout=>:landscape,:page_size => "A4"}
      end
    end
  end

  def new
    @insurance = EmployeeInsurancePolicy.new(:employee => @employee)
    @insurance.company = @company
  end

  def create
    @insurance = EmployeeInsurancePolicy.new(params[:employee_insurance_policy])
    @insurance.employee = @employee
    @insurance.company = @company
    if @insurance.save
      flash[:notice] = t('insurance.messages.create')
      redirect_to employee_insurances_path(@employee)
    else
      render :action=>:new
    end
  end

  def bulk
    @insurances = @company.active_employees.map do |emp|
      EmployeeInsurancePolicy.new(:company => @company,:employee => emp, :created_at => @date)
    end
  end

  def bulk_create
    errors = EmployeeInsurancePolicy.bulk_update_or_create(@company,params[:insurances])
    if errors.blank?
      flash[:notice] = t('insurance.messages.create')
      redirect_to :action=>:index
    else
      @errors = errors
      render :action=> :bulk
    end
  end

  def update
    if @insurance.update_attributes(params[:employee_insurance_policy])
      flash[:notice] = t('insurance.messages.update')
      redirect_to employee_insurances_path(@employee)
    else
      render :action=>:edit
    end
  end

  def destroy
    if @insurance.destroyable?
      @insurance.destroy
    else
      flash[:error] = t('insurance.messages.billed')
    end
    redirect_to employee_insurances_path(@employee)
  end

  private

  def load_insurance
    @insurance = EmployeeInsurancePolicy.find(params[:id])
  end

  def salary_sheet_not_found
    if params[:salary_sheet_id] && !@salary_sheet
      flash[:error] = "No salary sheet found for the #{params[:salary_sheet_id]}, create new?"
      redirect_to bulk_new_salary_sheet_insurance_path(params[:salary_sheet_id])
    end
  end

end
