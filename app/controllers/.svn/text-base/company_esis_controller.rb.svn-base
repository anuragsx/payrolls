class CompanyEsisController < CalculatorController

  before_filter :load_company_esi, :except => [:new, :create]

  def show
    if @company_esi.blank?
      flash[:notice] = t('esi.messages.set_company_esi')
      redirect_to new_company_esi_path
    end
  end
  
  def new
    @company_esi = CompanyEsi.new
    render :action => :edit
  end
  
  def create
    @company_esi = CompanyEsi.new(params[:company_esi])
    @company_esi.company = @company
    if @company_esi.save
      flash[:notice] = t('esi.messages.create')
      redirect_to company_esi_path
    else
      flash[:error] = t('esi.messages.error_creating')
      render :action => :edit
    end
  end
  
  def update
    if @company_esi.update_attributes(params[:company_esi])
      flash[:notice] = t('esi.messages.update')
      redirect_to company_esi_path
    else
      flash[:error] = t('esi.messages.error_updating')
      render :action => :edit
    end
  end
  
  def destroy
    @company_esi.destroy
    flash[:notice] = t('esi.messages.destroy')
    redirect_to company_path(@company)
  end

  private

  def load_company_esi
    @company_esi = CompanyEsi.scoped_by_company_id(@company).first
  end

  concerned_calculators(:esi)

end
