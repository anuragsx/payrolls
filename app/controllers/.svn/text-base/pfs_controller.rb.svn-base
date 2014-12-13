class PfsController < CalculatorController

  before_filter :read_financial_year, :only => [:index]
  before_filter :load_salary_sheet, :only => [:show, :form5, :form12a, :form10,:challan]
  before_filter :load_employee_pension, :only => [:edit, :exit, :destroy, :update]

  def index
    if @employee
      @employee_pf =  EmployeePension.for_company(@company).for_employee(@employee).first
      @slip_presenters = @employee.salary_slips.in_fy(@this_year).map{|c|SalarySlipPf.new(c)}
      respond_to do |format|
        format.html{ render :template=> "pfs/employee_pf" }
        format.pdf do
          @prawnto_options = {:filename => company_file_name(:action => 'From3A', :duration => params[:year]), :inline => false}
        end
        format.xml { render :xml => @employee_pf}
        format.json { render :json => @employee_pf}
      end
    else
      respond_to do |format|
        format.html do
          @salary_sheet_presenters = @company.salary_sheets.in_fy(@this_year).map{|s|SalarySheetPfPresenter.new(@company,s)}.group_by{|x|x.run_date.financial_half}
        end
        format.pdf do
          pdf = PfForm6a.new(@company,@this_year).generate_pdf
          send_data(pdf.render, :filename => company_file_name(:action => 'From6A',:duration => params[:year]), :type => 'application/pdf')
        end
      end      
    end
  end

  def show
    @presenter = SalarySheetPfPresenter.new(@company,@salary_sheet)
    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        return prawn_generated_pfs_pdf
      end
      format.xls do
        @excel = {:filename => company_file_name(:action => 'register', :duration => @presenter.month_date), :layout => false}
      end
    end
  end

  def new
    @employee_pf = EmployeePension.new(:employee => @employee)
    @employee_pf.company = @company
  end

  def create
    @employee_pf = EmployeePension.new(params[:employee_pension])
    @employee_pf.employee = @employee
    @employee_pf.company = @company
    @employee_pf.company_pf = CompanyPf.for_company(@company).try(:first)
    if @employee_pf.save
      flash[:notice] = t('pf.messages.employee.create')
      redirect_to employee_pfs_path(@employee)
    else
      render :action=>:new
    end
  end

  def update
    if @employee_pf.update_attributes(params[:employee_pension])
      flash[:notice] = t('pf.messages.employee.update')
      redirect_to employee_pfs_path(@employee)
    else
      render :action=>:edit
    end
  end

  def destroy
    @employee_pf.destroy
    redirect_to employee_pfs_path(@employee)
  end

  def form12a
    respond_to do |format|
      format.pdf do
        pdf = PfForm12a.new(@company,@salary_sheet).generate_pf_form12a
        send_data(pdf.render, :filename => company_file_name(:duration => @salary_sheet.formatted_run_date), :type => 'application/pdf')
      end
    end
  end

  def form5
    respond_to do |format|
      format.pdf do
        pf5 = PfForm5.new(@company,@salary_sheet)
        unless pf5.employees.blank?
          pdf = pf5.print_form5
          send_data(pdf.render, :filename => company_file_name(:duration => @salary_sheet.formatted_run_date), :type => 'application/pdf')
        else
          flash[:notice] = "#{t('pf.messages.employee.no_joining')} #{@salary_sheet.formatted_run_date}"
          redirect_to pf_path(@salary_sheet)
        end
      end
    end
  end

  def form10
    respond_to do |format|
      format.pdf do
        pf10 = PfForm10.new(@company,@salary_sheet)
        unless pf10.employees.blank?
          pdf = pf10.print_form10
          send_data(pdf.render, :filename => company_file_name(:duration => @salary_sheet.formatted_run_date), :type => 'application/pdf')
        else
          flash[:notice] = "#{t('pf.messages.employee.no_one_left')} #{@salary_sheet.formatted_run_date}"
          redirect_to pf_path(@salary_sheet)
        end       
      end
    end
  end
  
  def challan
    challan = PfChallan.new(@company,@salary_sheet)
    pdf = challan.generate_challan
    send_data(pdf.render, :filename => company_file_name(:duration => @salary_sheet.formatted_run_date), :type => 'application/pdf')
  end

  private

  def load_employee_pension
    @employee_pf = EmployeePension.find(params[:id])
  end

end
