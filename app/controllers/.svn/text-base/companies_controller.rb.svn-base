class CompaniesController < ApplicationController

  # GET /companies/1
  # GET /companies/1.xml
  def edit
    @address =  @company.address || @company.build_address
  end
  
  def show
    if @company.company_calculators.blank?
      flash[:notice] = t('company.messages.select_applicable')
      redirect_to new_company_calculator_path and return 
    end
  end

  # POST /companies
  # POST /companies.xml
  def create   
    @company = Company.new(params[:company])
    respond_to do |format|
      if @company.save
        flash[:notice] = t('company.messages.created')
        format.html { redirect_to new_company_calculator_path }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = current_account

    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = t('company.messages.updated')
        format.html { redirect_to(@company) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = current_account
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(companies_url) }
      format.xml  { head :ok }
    end
  end

  def delete_logo
    @company.update_attribute(:logo_file_name, nil)   
    redirect_to :action => 'edit'
  end
  
  def calculators
    @company = current_account
    @calculators = @company.company_calculators
    respond_to do |format|
      format.json { render :json => @calculators.to_json(:include => [:calculator]) }
      format.xml { render :xml => @calculators.to_xml(:include => [:calculator]) }
    end
  end

 
end

