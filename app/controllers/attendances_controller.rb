class AttendancesController < CalculatorController

  before_filter :read_calendar_year,:group_salary_sheets, :only => [:index]
  before_filter :load_attendance, :only => [:edit,:update,:destroy]

  def index
    if @employee
      @presenter = AttendancePresenter.new(@company,@employee,@this_year)
      respond_to do |format|
        format.html do
          render :action => 'employee_attendance'
        end
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end
    
  def show
    @date = Date.parse(params[:id])
    @attendances = Attendance.for_company(@company).for_employee(@employee).for_month(@date).all.index_by{|a|a.attendance_date}
    @dates = @date.month_dates.map{|d| @attendances[d] ||= Attendance.build_object(@company,@employee,d)}
  end
  
  def new
    @leave = Attendance.new
    render :action => 'form'
  end

  def create
    respond_to do |format|
      @attendance = Attendance.new(params[:attendance].merge({:company => @company,:employee =>@employee }))
      if @attendance.save
        flash[:notice] = "Attendance created"
        format.html do
          redirect_to employee_attendance_path(@employee,@attendance.attendance_date.to_s(:for_param))
        end
        format.xml  { render :xml => @attendance, :status => :created }
        format.json { render :json => @attendance, :status => :created}
      else
        format.html { render :action=>'form'}
        format.xml { render :xml => @attendance.errors, :status => :unprocessable_entity }
        format.json { render :json => @attendance.errors }
      end
    end
  end
    
  def edit
    render :action=>'form'
  end
  
  def update
    respond_to do |format|
      if @attendance.update_attributes(params[:attendance])
        flash[:notice] = "Attendance updated"
        format.html do
          redirect_to employee_attendance_path(@employee,@attendance.attendance_date.to_s(:for_param))
        end
        format.xml  { render :xml => @attendance }
        format.json { render :json => @attendance }
      else
        format.html { render :action=>'form'}
        format.xml { render :xml => @attendance.errors, :status => :unprocessable_entity }
        format.json { render :json => @attendance.errors }
      end
    end
  end
    
  def bulk
    @date = Date.parse(params[:id])
    respond_to do |format|
      format.html do
        @attendances = @company.active_employees.map{|emp|Attendance.build_object(@company,emp,@date)}
      end
      format.pdf do
        @presenter = MonthlyAttendancePresenter.new(@company,@date)
        @prawnto_options = {:filename => company_file_name(:duration => @date.to_s(:date_month_and_year)), :inline => false}
      end
    end
  end
  
  def bulk_create
    errors = Attendance.bulk_update_or_create(params[:attendance],@company)
    if errors.blank?
      redirect_to :action=>:index
    else
      @date = Date.parse(params[:id])
      @errors = errors
      render :action=> :bulk
    end
  end
  
  private
  
  def load_attendance
    @attendance ||= Attendance.find(params[:id])
  end
 
end
