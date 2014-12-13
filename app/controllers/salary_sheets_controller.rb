class SalarySheetsController < ApplicationController
  
  before_filter :read_financial_year, :only => [:index, :graph, :graph_data]
  before_filter :load_salary_sheet, :except => [:index, :new, :create, :expenditure, :graph, :graph_data]
  before_filter :check_running, :only => [:create]
  before_filter :check_future_sheets , :only => [:destroy]

  # GET /salary_sheets
  # GET /salary_sheets.xml
  def index
    sheets = @company.salary_sheets.in_fy(@this_year).all(:order => 'run_date asc')
    ss = sheets.index_by{|c|c.run_date.month}
    leave_info = CompanyLeave.for_company(@company).first
    @salary_sheets = @this_year.financial_months do |d|
      month_length = leave_info.try(:default_length,d) || Time.days_in_month(d.month,d.year)
      ss[d.month] || @company.salary_sheets.build(:run_date => d, :month_length => month_length)
    end
    @last = sheets.last
    @can_be_created = @salary_sheets.detect{|x| x.new_record? && !x.eligible_employees.size.zero?} unless (@last && @last.initial?) || (@last && @last.error?)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @salary_sheets }
      format.json  { render :json => @salary_sheets }
    end
  end

  def graph
    @graph = open_flash_chart_object(900,500, "/salary_sheets/graph_data/?this_year=#{@this_year}", true, '/', true)
  end

  def graph_data
    this_year = params[:this_year].to_i || Date.today.financial_year
    all_gross = ActiveSupport::OrderedHash.new
    this_year.financial_months.each do |date|
      sheet = @company.salary_sheets.for_month(date).first
      gross = sheet.salary_slips.sum(:gross).round if sheet
      all_gross[date] = (gross || 0)
    end
    
    g = Graph.new
    g.set_x_label_style(10, '#9933CC')
    g.set_y_label_steps(10)

    g.set_y_min(0)
    g.set_y_max(10000000)
    
    dates = (all_gross.keys).map(&:to_s)

    g.set_x_labels(dates)

    data = []
    all_gross.each do |key, value|
      data << value
    end

    g.set_data(data)
    g.line_hollow(2, 4, '0x80a033', 'Amount', 10)

    g.set_x_label_style( 10, '#CC3399', 2 );

    g.set_title("Salary Sheet Chart", '{font-size: 14px; color: #CC3399}')
    g.set_tool_tip("#val#")

    render :text => g.render
  end

  # GET /salary_sheets/1
  # GET /salary_sheets/1.xml
  def show
    @presenter = SalarySheetPresenter.new(@company,@salary_sheet)
    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        if @salary_sheet.doc.path
          send_file @salary_sheet.doc.path, :type => "application/pdf"
        else
          flash[:notice] = t('salary_sheet.messages.under_processing')
          redirect_to(@salary_sheet)
        end
      end
      format.xls do
        @excel = {:filename => company_file_name(:action => 'register') , :layout => false}
      end
      format.xml  { render :xml => @salary_sheet }
      format.json { render :json => @salary_sheet }
    end
  end

  def bank_statement
    respond_to do |wants|
      wants.pdf do
        unless @company.bank.blank?
          prawn_generated_bank_statement_pdf(@salary_sheet)
        else
          flash[:notice] = "#{t('salary_sheet.messages.no_bank')} #{@company.name}"
          redirect_to(@salary_sheet)
        end
      end
    end
  end

  # POST /salary_sheets
  # POST /salary_sheets.xml
  def create
    @salary_sheet = @company.salary_sheets.build(params[:salary_sheet])
    respond_to do |format|
      if @salary_sheet.save
        format.html do
          flash[:notice] = t('salary_sheet.messages.created')
          redirect_to(salary_sheets_path(:year => @salary_sheet.run_date.financial_year))
        end
        format.xml  { render :xml => @salary_sheet, :status => :created, :location => @salary_sheet }
        format.js
        format.json { render :json => @salary_sheet, :status => :created, :location => @salary_sheet }
      else
        flash[:error] = @salary_sheet.errors.on(:base) if @salary_sheet.errors.on(:base)
        format.html { redirect_to :action => :index }
        format.xml  { render :xml => @salary_sheet.errors, :status => :unprocessable_entity }
        format.json { render :json => @salary_sheet.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /salary_sheets/1
  # PUT /salary_sheets/1.xml
  def update
    respond_to do |format|
      if @salary_sheet.update_attributes(params[:salary_sheet])
        flash[:notice] = t('salary_sheet.messages.updated')
        format.html { redirect_to(@salary_sheet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @salary_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /salary_sheets/1
  # DELETE /salary_sheets/1.xml
  def destroy
    @salary_sheet.destroy
    respond_to do |format|
      format.html { redirect_to(salary_sheets_path(:year => @salary_sheet.run_date.financial_year)) }
      format.xml  { head :ok }
    end
  end

  def head_view
    @expenditure = Array.new()
    @total = 0
    @salary_sheet.salary_slip_charges.group_by{|ch| ch.salary_head}.each do |k,v|
      total = v.sum(&:amount).abs
      @expenditure << {k => total}
      @total += total
    end
  end
  
  def send_email
    DocMailer.send_later(:deliver_sent_salary_sheet,@current_user,@salary_sheet)
    respond_to do |format|
      flash[:notice] = t('salary_sheet.messages.email_sent')
      format.html { redirect_to(@salary_sheet) }
      format.xml  { head :ok }
    end
  end

  def send_sms    
    @salary_sheet.send_later(:send_sms_by_delayed_job)  
    respond_to do |format|
      flash[:notice] = t('salary_sheet.messages.sms_sent')
      format.html { redirect_to(@salary_sheet) }
      format.xml  { head :ok }
    end
  end

  private 
  
  def check_running
    if @company.salary_sheets.scoped_by_status("initial").any?
      flash[:error] = t('salary_sheet.messages.being_processed')
      redirect_to salary_sheets_path(:year => params[:salary_sheet][:run_date].to_datetime.financial_year)
      return
    end
  end

  def check_future_sheets
    if @company.salary_sheets.after_date(@salary_sheet.run_date).any?
      flash[:error] = t('salary_sheet.messages.exists_in_future')
      redirect_to salary_sheets_path(:year => @salary_sheet.run_date.financial_year)
    end
  end

end
