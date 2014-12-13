class LtasController < ApplicationController
  # GET /ltas
  # GET /ltas.xml
  def index
    @ltas = Lta.for_company(@company).for_employee(@employee)
    @lta_claims = LtaClaim.for_company(@company).for_employee(@employee).group_by(&:block)
    respond_to do |format|
      if @ltas.blank?
        format.html{redirect_to new_employee_lta_path(@employee)}
      else
        format.html # index.html.erb
        format.xml  { render :xml => @ltas }
      end
    end
  end

 
  # GET /ltas/new
  # GET /ltas/new.xml
  def new
    @lta = Lta.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lta }
    end
  end

  # GET /ltas/1/edit
  def edit
    @lta = Lta.find(params[:id])
  end

  # POST /ltas
  # POST /ltas.xml
  def create
    @lta = Lta.new(params[:lta])
    @lta.employee = @employee
    @lta.company = @company
    if !params[:lta][:created_at].blank?
      date = Date.parse(params[:lta][:created_at])
      @lta.block = date.exempt_block
    end
    respond_to do |format|
      if @lta.save
        flash[:notice] = 'Lta was successfully created.'
        format.html { redirect_to employee_ltas_path(@employee) }
        format.xml  { render :xml => @lta, :status => :created, :location => @lta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ltas/1
  # PUT /ltas/1.xml
  def update
    @lta = Lta.find(params[:id])

    respond_to do |format|
      if @lta.update_attributes(params[:lta])
        flash[:notice] = 'Lta was successfully updated.'
        format.html { redirect_to employee_ltas_path(@employee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lta.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end


