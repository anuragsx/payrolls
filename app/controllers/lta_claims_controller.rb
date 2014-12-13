class LtaClaimsController < ApplicationController
 
  # GET /lta_claims/new
  # GET /lta_claims/new.xml
  def new
    @lta_claim = LtaClaim.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lta_claim }
    end
  end

  # GET /lta_claims/1/edit
  def edit
    @lta_claim = LtaClaim.find(params[:id])
  end

  # POST /lta_claims
  # POST /lta_claims.xml
  def create
    @lta_claim = LtaClaim.new(params[:lta_claim])
    @lta_claim.employee = @employee
    @lta_claim.company = @company
    if !params[:lta_claim][:created_at].blank?
      date = Date.parse(params[:lta_claim][:created_at])
      @lta_claim.block = date.exempt_block
      @lta_claim.claim_year = date.year
    end
    respond_to do |format|
      if @lta_claim.save
        flash[:notice] = 'LtaClaim was successfully created.'
        format.html { redirect_to employee_ltas_path(@employee) }
        format.xml  { render :xml => @lta_claim, :status => :created, :location => @lta_claim }
      else
        flash[:notice] = "LtaClaim was not successfully created."
        format.html { render :action => "new" }
        format.xml  { render :xml => @lta_claim.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lta_claims/1
  # PUT /lta_claims/1.xml
  def update
    @lta_claim = LtaClaim.find(params[:id])
    respond_to do |format|
      if @lta_claim.update_attributes(params[:lta_claim])
        flash[:notice] = 'LtaClaim was successfully updated.'
        format.html { redirect_to employee_ltas_path(@employee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lta_claim.errors, :status => :unprocessable_entity }
      end
    end
  end
end

