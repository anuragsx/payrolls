class CompanyPfsController < CalculatorController

  before_filter :load_company_pf, :except => [:new, :create]

  def show
    if @company_pf.blank?
      flash[:notice] = t('pf.messages.set')
      redirect_to new_company_pf_path
    end
  end
  
  def new
    @company_pf = CompanyPf.new
    render :action => :edit
  end
  
  def create
    @company_pf = CompanyPf.new(params[:company_pf])
    @company_pf.company = @company
    if @company_pf.save
      flash[:notice] = t('pf.messages.create')
      redirect_to company_pf_path
    else
      flash[:error] = t('pf.messages.error_creating')
      render :action => :edit
    end
  end
  
  def update
    if @company_pf.update_attributes(params[:company_pf])
      flash[:notice] = t('pf.messages.update')
      redirect_to company_pf_path
    else
      flash[:error] = t('pf.messages.error_updating')
      render :action => :edit
    end
  end
  
  def destroy
    @company_pf.destroy
    flash[:notice] = t('pf.messages.destroy')
    redirect_to company_path(@company)
  end

  private

  def load_company_pf
    @company_pf = CompanyPf.scoped_by_company_id(@company).last
  end

  concerned_calculators(:pf)
  
end