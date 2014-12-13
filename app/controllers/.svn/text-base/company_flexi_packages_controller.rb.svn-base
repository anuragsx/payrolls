class CompanyFlexiPackagesController < CalculatorController

  def index
    @company_flexi_packages = CompanyFlexiPackage.scoped_by_company_id(@company).all
    @company_flexi = CompanyFlexiPackage.scoped_by_company_id(@company).map{|s| s.salary_head_id}.uniq
    @company_allowances = CompanyAllowanceHead.scoped_by_company_id(@company).select{|s| !@company_flexi.include?(s.salary_head_id)}
  end

  def new      
    @company_flexi_package = CompanyFlexiPackage.new
    @company_flexi = CompanyFlexiPackage.scoped_by_company_id(@company).map{|s| s.salary_head_id}.uniq
    @company_allowances = CompanyAllowanceHead.scoped_by_company_id(@company).select{|s| !@company_flexi.include?(s.salary_head_id)}
  end

  def create       
    @company_flexi_package = CompanyFlexiPackage.new
    @company_flexi = CompanyFlexiPackage.scoped_by_company_id(@company).map{|s| s.salary_head_id}.uniq
    @company_allowances = CompanyAllowanceHead.scoped_by_company_id(@company).select{|s| !@company_flexi.include?(s.salary_head_id)}
    if @company_flexi_package.create_company_flexi_package(params,@company)
      flash[:notice] = t('package.messages.create')
      redirect_to edit_company_flexi_package_path(@company)
    else
      flash[:error]= @company_flexi_package.errors.to_s
      render :action => "new"
    end    
  end
 
  def edit
    Company.send(:has_many, :company_flexi_packages)  
    Company.send(:accepts_nested_attributes_for, :company_flexi_packages, :allow_destroy => true)
  end

  def update    
    Company.send(:has_many, :company_flexi_packages)
    Company.send(:accepts_nested_attributes_for, :company_flexi_packages, :allow_destroy => true)
    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice]= t('package.messages.update')
        format.html { redirect_to company_flexi_packages_path}
        format.xml  { head :ok }
      else        
        flash[:error]= "#{t('package.message.error_updating')} #{@company.errors.to_s}"
        format.html { render :action => "edit" }        
      end
    end    
  end

  def destroy    
    @company_flexi_package = CompanyFlexiPackage.find_all_by_salary_head_id(params[:id])    
    @company_flexi_package.map(&:destroy)
    respond_to do |format|
      format.html { redirect_to(company_flexi_packages_path) }
      format.xml  { head :ok }
    end
  end

  concerned_calculators(:flexible_allowance)

end
