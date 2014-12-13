class IncentivesController < ApplicationController
  before_filter :read_financial_year, :only => [:index]
  before_filter :group_salary_sheets, :only => [:index]
  before_filter :check_no_salary_sheet_exists, :only => [:bulk]
  before_filter :salary_sheet_not_found, :only => [:index]

  def index
    respond_to do |format|
      unless @salary_sheet
        @incentives = Incentive.search(@company,@this_year,@employee)
        if @incentives.empty?
          flash[:info] = t('incentive.messages.not_exists')
          if @employee
            format.html {redirect_to(new_employee_incentive_path(@employee)) and return}
          end
          format.xml  { render :xml => @incentives }
          format.json { render :json => @incentives }
        end      
        format.html
        format.pdf do
          @prawnto_options = {:filename=> company_file_name(:action => 'register')}
        end
        format.xml  { render :xml => @incentives.values.flatten! }
        format.json { render :json => @incentives.values.flatten! }
      else
        @charges = SalaryHead.charges_for_incentive.on_salary_sheet(@salary_sheet).all
        format.html {render :action => 'sheet_view'}
      end
    end
  end

  def detailed_info
    @search_date = Date.parse(params[:search_date])
    @incentives = Incentive.detail_search(@company,params,@search_date)
    respond_to do |format|
      format.js
    end
  end

  def show
    @incentive = Incentive.find(params[:id])
  end

  def bulk
    @prev_month = @date - 1.month
    @next_month = @date + 1.month
    @incentives = Incentive.for_company(@company).incentive_in(@date)
    @new_incentives = @company.employees.map do |emp|
      Incentive.new(:company => @company,:employee => emp,:incentive_at => @this_month)
    end
  end

  def bulk_create
    @date = Date.parse(params[:date]).to_datetime
    @errors = Incentive.create_multi(params[:incentives],@company,@date)
    if @errors.blank?
      flash[:notice] = t('incentive.messages.create')
      redirect_to :action=>:index
    else
      @prev_month = @date - 1.month
      @next_month = @date + 1.month
      render :action=> :bulk
    end
  end

  def new
    @incentive = Incentive.new(:employee => @employee)
  end

  def create
    @incentive = Incentive.new(params[:incentive])
    @incentive.employee = @employee
    @incentive.company = @company
    if @incentive.save
      flash[:notice] = t('incentive.messages.create')
      redirect_to employee_incentives_path(@employee)
    else
      render :action => 'new'
    end
  end

  def edit
    @incentive = Incentive.find(params[:id])
  end

  def update
    @incentive = Incentive.find(params[:id])
    if @incentive.update_attributes(params[:incentive])
      flash[:notice] = t('incentive.messages.update')
      redirect_to employee_incentives_path(@employee)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @incentive = Incentive.find(params[:id])
    unless @incentive.billed?
      @incentive.destroy
      flash[:notice] = t('incentive.messages.destroy')
    else
      flash[:error] = t('incentive.messages.billed')
    end
    redirect_to employee_incentives_path(@employee)
  end

  private

  def salary_sheet_not_found
    if params[:salary_sheet_id] && !@salary_sheet
      flash[:error] = "No salary sheet found for the #{params[:salary_sheet_id]}, create new?"
      redirect_to bulk_new_salary_sheet_incentive_path(params[:salary_sheet_id])
    end
  end
end
