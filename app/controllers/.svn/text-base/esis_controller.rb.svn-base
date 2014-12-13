class EsisController < CalculatorController

  before_filter :read_financial_year, :only => [:index]
  before_filter :load_employee_esi, :only => [:edit, :update, :destroy]
  before_filter :load_salary_sheet, :only => [:show,:challan]

  def index
    respond_to do |format|
      if @employee
        @employee_esi = EmployeeEsi.for_company(@company).for_employee(@employee).first
        @slip_presenters = @employee.salary_slips.in_fy(@this_year).map{|c|SalarySlipEsi.new(c)}
        format.html { render :template=> "esis/employee_esis"}
        format.xml { render :xml => @employee_esi}
        format.json { render :json => @employee_esi}
      else
        @salary_sheet_presenters = @company.salary_sheets.map{|s|SalarySheetEsiPresenter.new(@company,s)}.group_by{|x|x.run_date.financial_half}
        format.html
      end
      format.pdf do
        start_date = read_half(params[:half])
        pdf = EsiForm5.new(@company,start_date).generate_form_5
        send_data(pdf.render, :filename => company_file_name(:action => "form5", :duration => params[:half]), :type => 'application/pdf')
      end
    end
  end

  def show
    @presenter = SalarySheetEsiPresenter.new(@company,@salary_sheet)
    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        prawn_generated_esis_pdf
      end
      format.xls do
        @excel = {:filename => company_file_name(:action => "register", :duration => @presenter.month_date), :layout => false}
      end
    end
  end

  def new
    @employee_esi = EmployeeEsi.new
    @employee_esi.employee = @employee
    @employee_esi.company = @company
  end

  def create
    @employee_esi = EmployeeEsi.new(params[:employee_esi])
    @employee_esi.employee = @employee
    @employee_esi.company = @company
    if @employee_esi.save
      flash[:notice] = t('esi.messages.employee.create')
      redirect_to employee_esis_path(@employee)
    else
      render :action=>:new
    end
  end

  def update
    if @employee_esi.update_attributes(params[:employee_esi])
      flash[:notice] = t('esi.messages.employee.update')
      redirect_to employee_esis_path(@employee)
    else
      render :action=>:edit
    end
  end

  def destroy
    @employee_esi.destroy
    redirect_to employee_esis_path(@employee)
  end
  
  def challan
    pdf = EsiChallan.new(@company,@salary_sheet).generate_challan
    send_data(pdf.render, :filename => company_file_name, :type => 'application/pdf')
  end

  private

  def load_employee_esi
    @employee_esi = EmployeeEsi.for_company(@company).find(params[:id])
  end

  def read_half(half)
    if (half =~ /(H.) (\d\d\d\d)/)
      return Date.financial_year_start($2.to_i).send('beginning_of_financial_'+$1.downcase)
    end
  end
end
