class ArrearsController < ApplicationController
  before_filter :read_financial_year, :only => [:index]
  before_filter :group_salary_sheets, :only => [:index]
  before_filter :check_no_salary_sheet_exists, :only => [:bulk]
  before_filter :salary_sheet_not_found, :only => [:index]

  def index
    respond_to do |format|
      unless @salary_sheet
        @arrears = Arrear.search(@company,@this_year,@employee)
        if @arrears.empty?
          flash[:info] = t('arrear.messages.not_exists')
          if @employee
            format.html {redirect_to(new_employee_arrear_path(@employee)) and return}
          end
          format.xml  { render :xml => @arrears }
          format.json { render :json => @arrears }
        end
        format.html
        format.pdf do
          @prawnto_options = {:filename=> company_file_name(:action => 'register')}
        end
        format.xml  { render :xml => @arrears.values.flatten! }
        format.json { render :json => @arrears.values.flatten! }
      else
        @charges = SalaryHead.charges_for_arrear.on_salary_sheet(@salary_sheet).all
        format.html {render :action => 'sheet_view'}
      end
    end
  end


  def show
    @arrear = Arrear.find(params[:id])
  end

  def bulk
    @prev_month = @date - 1.month
    @next_month = @date + 1.month
    @arrears = Arrear.for_company(@company).arrear_in(@date)
    @new_arrears = @company.employees.map do |emp|
      Arrear.new(:company => @company,:employee => emp,:arrear_at => @this_month)
    end
  end

  def bulk_create
    @date = Date.parse(params[:date]).to_datetime
    @errors = Arrear.create_multi(params[:arrears],@company,@date)
    if @errors.blank?
      flash[:notice] = t('arrear.messages.create')
      redirect_to :action=>:index
    else
      @prev_month = @date - 1.month
      @next_month = @date + 1.month
      render :action=> :bulk
    end
  end

  def new
    @arrear = Arrear.new(:employee => @employee)
  end

  def create
    @arrear = Arrear.new(params[:arrear])
    @arrear.employee = @employee
    @arrear.company = @company
    if @arrear.save
      flash[:notice] = t('arrear.messages.create')
      redirect_to employee_arrears_path(@employee)
    else
      render :action => 'new'
    end
  end

  def edit
    @arrear = Arrear.find(params[:id])
  end

  def update
    @arrear = Arrear.find(params[:id])
    if @arrear.update_attributes(params[:arrear])
      flash[:notice] = t('arrear.messages.update')
      redirect_to employee_arrears_path(@employee)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @arrear = Arrear.find(params[:id])
    unless @arrear.billed?
      @arrear.destroy
      flash[:notice] = t('arrear.messages.destroy')
    else
      flash[:error] = t('arrear.messages.billed')
    end
    redirect_to employee_arrears_path(@employee)
  end

  private

  def salary_sheet_not_found
    if params[:salary_sheet_id] && !@salary_sheet
      flash[:error] = "No salary sheet found for the #{params[:salary_sheet_id]}, create new?"
      redirect_to bulk_new_salary_sheet_arrear_path(params[:salary_sheet_id])
    end
  end
end
