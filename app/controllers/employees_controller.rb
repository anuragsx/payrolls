class EmployeesController < ApplicationController

  $field_label = {:resign => "resignation", :suspend => "suspension", :activate => "activation"}
  #before_filter :check_account, :only => [:new, :create, :new_import, :import]
  before_filter :employee_status_change, :only => [:resign, :suspend, :activate]
  before_filter :new_employee_state, :only => [:new_resign, :new_suspend, :new_activate]

  # GET /employees
  # GET /employees.xml
  def index
    @search = @company.employees.search(params[:search])
    @employees = @search.all
    @department = Department.find_by_id(@search.department_id_equals).try(:name)
    @search.name_like_any = @search.name_like_any.try(:join, " ")     
    respond_to do |format|
      if @employees.empty? and params[:search].blank?
        format.html do
          flash[:info] = t('employees.messages.no_employee')
          redirect_to new_import_employees_path
        end
        format.xml  { render :xml => @employees.to_xml(api_methods) }
        format.json { render :json => @employees.to_json(api_methods)}
      else
        format.html
        format.xml  { render :xml => @employees.to_xml(api_methods) }
        format.json { render :json => @employees.to_json(api_methods) }
      end
    end
  end

  # GET /employees/1
  # GET /employees/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employee.to_xml(api_methods)}
      format.json { render :json => @employee.to_json(api_methods)}
    end
  end

  # GET /employees/new
  # GET /employees/new.xml
  def new
    @employee = @company.employees.build(:bank => @company.bank)
    @employee.employee_packages.build
    #@address = @employee.build_address
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @employee.to_xml(api_methods)}
      format.json { render :json => @employee.to_json(api_methods)}
    end
  end

  # GET /employees/1/edit
  def edit
    @address =  @employee.address || @employee.build_address
  end

  # POST /employees
  # POST /employees.xml
  def create
    @key = params[:key] if params[:key]
    @employee = @company.employees.build(params[:employee])
    respond_to do |format|
      if @employee.save
        flash[:notice] = t('employees.messages.create')
        format.html { redirect_to new_employee_employee_package_path(@employee) }
        format.js
        format.xml  { render :xml => @employee.to_xml(api_methods), :status => :created, :location => @employee }
        format.json { render :json => @employee.to_json(api_methods), :status => :created, :location => @employee }
      else
        format.html { render :action => "new" }
        format.js
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
        format.json { render :json => @employee.errors }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.xml
  def update
    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        flash[:notice] = t('employees.messages.update')
        format.html { redirect_to employee_path(@employee) }
        format.xml  { render :xml => @employee.to_xml(api_methods), :location => @employee }
        format.json { render :json => @employee.to_json(api_methods),:location => @employee }
      else
        format.html { render :action => "edit"}
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
        format.json { render :json => @employee.errors }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.xml
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_path }
      format.xml  { head :ok}
      format.json { head :ok}
    end
  end

  def import
    begin
      @employees = EmployeeBulkImporter.new(@company,params[:excel_file]).import
      flash[:notice] = "#{@employees.size} employees loaded."
      redirect_to employees_path
    rescue Exception => e
      flash[:error] = "#{t('employees.messages.error_uploading')} : #{e.to_s}"
      redirect_to new_import_employees_path
    end
  end

  def bulk_create
    @employees = []
    @errors = []
    params[:employees].each do |emp|
      employee = Employee.new(emp)
      employee.company = @company
      unless employee.employee_packages.blank?
        employee.employee_packages.first.company = @company
        employee.employee_packages.first.start_date = employee.commencement_date
      end
      unless employee.save
        @errors << employee.errors
        @employees <<  employee
      end
    end
    if @employees.blank?
      flash[:notice] = t('employees.messages.loading_success')
    else
      flash[:error] = t('employees.messages.error_loading')
    end
    render :action => :new_import
  end

  def identity_card
    @employee = @company.employees.find(params[:id])
    render :layout=>false
  end

  protected

  def current_employee
    @employee = @company.employees.find(params[:id]) if params[:id]
  end

  private

  def check_account
    unless current_account.can_add_employees?
      flash[:error] = t('employees.messages.cant_add_employee')
      redirect_to employees_path and return false
    end
  end
  
  def employee_status_change
    @employee.resign_date = params[:employee][:resign_date]
    @employee.earned_leaves = params[:employee][:earned_leaves]
    @employee.current_balance = params[:employee][:current_balance]
    @employee.send("#{params[:action]}!")
    redirect_to employee_path(@employee)
  end

  def new_employee_state
    if @employee.employee_packages.blank?
      redirect_to new_employee_employee_package_path(@employee)
    else
      state = params[:action].gsub(/new_/,'')
      @field_label = $field_label[state.to_sym]
      @form_path = send("#{state}_employee_path",@employee)
      render :action => "employee_status"
    end
  end
  
  def api_methods
    {:methods => [:company_name,:department_name,:bank_name,:formatted_commencement_date,:designation,:current_package_id]}
  end

end