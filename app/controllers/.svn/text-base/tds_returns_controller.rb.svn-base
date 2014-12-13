class TdsReturnsController < ApplicationController
  # GET /tds_returns
  # GET /tds_returns.xml
  before_filter :read_financial_year, :only => [:index]

  def index
    @q_years = TdsReturn.for_financial_year(@company,@fy_start)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /tds_returns/1
  # GET /tds_returns/1.xml
  def show
    @date = read_quarter(params[:id])
    @tds_return = TdsReturn.build_object(@company,@date)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @tds_return }
      format.pdf do
        pdf = Form27a.new(@company,@tds_return).download_from_27a
        send_data(pdf.render, :filename => company_file_name(:action => 'Form27A', :duration => @tds_return.quarter))
      end
    end
  end

  def update
    @tds_return = TdsReturn.scoped_by_company_id(@company).find(params[:id])
    respond_to do |format|
      if @tds_return.update_attributes(params[:tds_return])
        flash[:notice] = "TDS Return successfully updated"
        format.html { redirect_to tds_returns_path }
        format.xml  { render :xml => @tds_return, :status => :created, :location => @tds_return }
      else
        flash[:error] = "Error updating TDS Return"
        redirect_to :back
      end
    end
  end

  # POST /tds_returns
  # POST /tds_returns.xml
  def create
    @tds_return = TdsReturn.new(merge_attr!(params[:tds_return]))
    respond_to do |format|
      if @tds_return.save
        flash[:notice] = "TDS Return successfully created"
        format.html { redirect_to tds_returns_path }
        format.xml  { render :xml => @tds_return, :status => :created, :location => @tds_return }
      else
        @date = params[:tds_return][:start_date].to_date
        render :action => :show
      end
    end
  end

  private
  def merge_attr!(attr)
    attr.merge!({:company =>  @company})
    attr[:employee_tds_returns_attributes].each {|att,value|attr[:employee_tds_returns_attributes][att].merge!({:company =>  @company})} if attr[:employee_tds_returns_attributes]
    attr
  end

  def read_quarter(quarter)
    if (quarter =~ /(Q.) (\d\d\d\d)/)
      return Date.financial_year_start($2.to_i).send('beginning_of_financial_'+$1.downcase)
    end
  end
end
