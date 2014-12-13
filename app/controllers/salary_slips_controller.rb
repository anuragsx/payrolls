class SalarySlipsController < ApplicationController

  before_filter :read_financial_year, :only => [:index]
  # GET /salary_slips
  # GET /salary_slips.xml
  def index
    if @employee
      @salary_slips = SalarySlip.scoped_by_employee_id(@employee).scoped_by_financial_year(@this_year).all(:joins => :salary_sheet, :order => 'salary_sheets.run_date')
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @salary_slips }
        format.json  { render :json => @salary_slips }
      end
    else
      respond_to do |format|
        format.pdf do
         prawn_generate_condensed_salary_slip
        end
      end
    end
  end

  # GET /salary_slips/1
  # GET /salary_slips/1.xml
  def show
    @salary_slip = SalarySlip.find(params[:id], :include => [:employee, :company, :salary_sheet, {:salary_slip_charges => :salary_head}])
    @presenter = SalarySlipPresenter.new(@salary_slip)
    respond_to do |format|
      format.html { @employee = @presenter.employee }
      format.pdf do
        if @salary_slip.doc.path
          send_file @salary_slip.doc.path, :type => "application/pdf"
        else
          flash[:notice] = t('salary_slip.messages.under_processing')
          redirect_to(@salary_slip)
        end
      end
      format.xml  { render :xml => @salary_slip }
      format.json  { render :json => @salary_slip }
    end
  end

  # POST /salary_slips
  # POST /salary_slips.xml
  def create
    @salary_slip = SalarySlip.new(params[:salary_slip])
    @salary_slip.company = @company
    respond_to do |format|
      if @salary_slip.save
        flash[:notice] = t('salary_slip.messages.created')
        format.html { redirect_to(@salary_slip) }
        format.xml  { render :xml => @salary_slip, :status => :created, :location => @salary_slip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @salary_slip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /salary_slips/1
  # PUT /salary_slips/1.xml
  def update
    @salary_slip = SalarySlip.find(params[:id])

    respond_to do |format|
      if @salary_slip.update_attributes(params[:salary_slip])
        flash[:notice] = t('salary_slip.messages.updated')
        format.html { redirect_to(@salary_slip) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @salary_slip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /salary_slips/1
  # DELETE /salary_slips/1.xml
  def destroy
    @salary_slip = SalarySlip.find(params[:id])
    @salary_slip.destroy

    respond_to do |format|
      format.html { redirect_to(salary_slips_url) }
      format.xml  { head :ok }
    end
  end
  
  def send_email
    @salary_slip = SalarySlip.find(params[:id])
    DocMailer.send_later(:deliver_sent_salary_slip,@salary_slip, @company)
    respond_to do |format|
      flash[:notice] = "#{t('salary_slip.messages.email_sent')} #{@salary_slip.employee.name}"
      format.html { redirect_to(@salary_slip) }
      format.xml  { head :ok }
    end
  end

end
