class LeavesController < ApplicationController

  before_filter :read_calendar_year, :salary_sheet_not_found, :only => [:index]
  before_filter :load_leave, :only=>[:edit,:update,:destroy]
  before_filter :group_salary_sheets, :read_financial_year, :only => [:index]
  
  def index
    if @employee
      @leaves = {}
      @monthlies = @this_year.calendar_months do |m|
        @leaves[m.month] || EmployeeLeave.build_object(@company,@employee,m)
      end
      respond_to do |format|
        format.html do
          render :action => 'employee_leaves'
        end
        format.pdf do
          @prawnto_options = {:filename => company_file_name(:action => "for_#{@employee.name}", :duration => @this_year.to_s), :inline => false}
          render :template=> "leaves/employee_leaves"
        end
        format.json {render :json => @monthlies}
        format.xml {render :xml => @monthlies}
      end
    elsif @salary_sheet
      @leaves = EmployeeLeave.detail_search(@company,@salary_sheet.run_date)
      respond_to do |format|
        format.html do
          render :action => 'sheet_view'
        end
        format.pdf do
          @prawnto_options = {:filename => company_file_name(:action => 'details',
              :duration  => @salary_sheet.formatted_run_date), :inline => false}
        end
      end
    else
      @leaves = EmployeeLeave.search(@company,@this_year)
    end
  end

  def show
    @leave = EmployeeLeave.find(params[:id])
  end

  def new
    @leave = EmployeeLeave.new
    @leave.setup_leave_type
    render :action => 'form'
  end

  def edit
    @leave.setup_leave_type
    render :action=>'form'
  end

  def create
    respond_to do |format|
      @leave = EmployeeLeave.new(merge_attr(params[:employee_leave]))
      @leave.employee = @employee
      if @leave.save
        flash[:notice] = t('leaves.messages.employee.create')
        format.html do
          redirect_to employee_leaves_path(@employee)
        end
        format.xml  { render :xml => @leave, :status => :created }
        format.json { render :json => @leave, :status => :created}
      else
        format.html { render :action=>'form'}
        format.xml { render :xml => @leave.errors, :status => :unprocessable_entity }
        format.json { render :json => @leave.errors }
      end
    end
  end

  def update
    if @leave.update_attributes(merge_attr(params[:employee_leave]))
      flash[:notice] = t('leaves.messages.employee.update')
      redirect_to employee_leaves_path(@employee)
    else
      render :action=>'form'
    end
  end

  def bulk
    @date = Date.parse(params[:salary_sheet_id]).try(:beginning_of_month) || Date.today
    @next_month = @date + 1.month
    @prev_month = @date - 1.month
    @leaves = []
    @company.active_employees.each do |emp|
      @leaves << EmployeeLeave.build_object(@company,emp,@date)
    end
    respond_to do |format|
      format.html
      format.xls do
        @excel = {:filename => company_file_name(:action => 'bulk', :duation => @date.to_s(:short_month_and_year)) , :layout => false}
      end
    end
  end

  def bulk_create
    errors = EmployeeLeave.bulk_update_or_create(params[:leaves].map{|leave|merge_attr(leave)})
    if errors.blank?
      flash[:notice] = t('leaves.messages.employee.create')
      redirect_to :action=>:index
    else
      @date = Date.parse(params[:leaves][0][:created_at]) || Date.today
      @next_month = @date + 1.month
      @prev_month = @date - 1.month
      @errors = errors
      render :action=> :bulk
    end
  end

  def excel_bulk_create
    begin
      @leaves = EmployeeLeaveImporter.new(@company,params[:excel_file]).import
      flash[:notice] = t('leaves.messages.employee.uploaded')
      redirect_to leaves_path
    rescue Exception => e
      flash[:error] = "#{t('leaves.messages.employee.error_loading')} : #{e.to_s}"
      redirect_to excel_bulk_leaves_path
    end
  end

  def detailed_info
    @search_date = Date.parse(params[:search_date])
    @leaves = EmployeeLeave.detail_search(@company,@search_date,params[:employee])
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @leave.destroy
    redirect_to employee_leaves_path(@employee)
  end

  private
  def load_leave
    @leave ||= EmployeeLeave.find(params[:id])
  end

  def salary_sheet_not_found
    if params[:salary_sheet_id] && !@salary_sheet
      flash[:error] = "No salary sheet found for the #{params[:salary_sheet_id]}, create new?"
      redirect_to bulk_new_salary_sheet_leafe_path(params[:salary_sheet_id])
    end
  end

  def merge_attr(attr)
      attr.to_hash
      attr.merge!(:company => @company,
      :casual_leave_attributes => attr[:casual_leave_attributes].merge!(:company => @company),
      :privilege_leave_attributes => attr[:privilege_leave_attributes].merge!(:company => @company),
      :sick_leave_attributes => attr[:sick_leave_attributes].merge!(:company => @company))
  end

end
