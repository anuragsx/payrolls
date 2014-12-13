class EmployeePackagesController < ApplicationController

  def show
    @employee_package = EmployeePackage.find(params[:id])
    @employee_packages = @employee.employee_packages.reverse
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employee_packages }
      format.json { render :json => @employee_packages}
    end
  end
 
  def new
    @current_package = @employee.current_package
    @employee_package = @employee.employee_packages.build(:start_date => Date.today)
  end

  def edit
    @current_package = EmployeePackage.find(params[:id])
  end

  def create
    respond_to do |format|
      if @employee.promote!(params)
        flash[:notice] = t('employees.package.messages.employee_pkg.create')
        format.html { redirect_to(employee_employee_package_path(@employee,@employee.current_package)) }
      else
        flash[:error]= t('employees.package.messages.employee_pkg.error_creating')
        format.html { redirect_to :action => 'new' ,:employee_id => @employee}
      end
    end
  end
  
  def update
    @employee_package = EmployeePackage.find(params[:id])  
    respond_to do |format|
      if @employee.promote!(params)
        flash[:notice] = t('employees.package.messages.employee_pkg.update')
        format.html { redirect_to(employee_employee_package_path(@employee,@employee_package)) }
      else
        flash[:error]= t('employees.package.messages.employee_pkg.error_updating')
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @employee_package = EmployeePackage.find(params[:id])
    respond_to do |format|
      if @employee_package.destroy
        flash[:notice] = t('employees.package.messages.employee_pkg.destroy')
        if @employee.current_package
          format.html { redirect_to(employee_employee_package_path(@employee,@employee.current_package)) }
        else
          format.html { redirect_to(employee_path(@employee)) }
        end
      else
        flash[:error]= t('employees.package.messages.employee_pkg.error_destroying')
        format.html { redirect_to(employee_employee_package_path(@employee, @employee_package)) }
      end
    end
  end

  def ctc
    @employee_package = EmployeePackage.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        @prawnto_options = {:filename => company_file_name(:action => "CTC_#{@employee.name}"), :inline => false}
      end
      format.xml  { render :xml => @employee_package }
      format.json { render :json => @employee_package}
    end
  end
  
end
