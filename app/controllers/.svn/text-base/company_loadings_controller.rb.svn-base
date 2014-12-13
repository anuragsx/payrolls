class CompanyLoadingsController < CalculatorController

  before_filter :load_dearness_relief, :except=>[:index,:create,:new]

  def create
    @dearness_relief = CompanyLoading.new(params[:company_loading])
    @dearness_relief.company = @company
    if @dearness_relief.save
      flash[:notice] = t('dearness_relief.messages.create')
      redirect_to company_loadings_path
    else
      render :action => :index
    end
  end

  def update
    if @dearness_relief.update_attributes(params[:company_loading])
      flash[:notice] = t('dearness_relief.messages.update')
      redirect_to company_loadings_path
    else
      render :action=>:edit
    end
  end

  def destroy
    @dearness_relief.destroy
    respond_to do |format|
      format.html { redirect_to(company_loadings_path) }
      format.xml  { head :ok }
    end
  end

  private

  def load_dearness_relief
    @dearness_relief = CompanyLoading.scoped_by_company_id(@company).last
  end

  concerned_calculators(:dearness_relief)

end
