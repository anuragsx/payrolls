class CompanyProfessionalTaxesController < CalculatorController
  
  before_filter :load_professional_tax, :except => [:new, :create]
  
  def show
    if @company_professional_tax.blank?
      flash[:notice] = t('professional_tax.messages.set')
      redirect_to :action => :new and return
    end
  end
  
  def new
    @company_professional_tax = CompanyProfessionalTax.new()
    render :action => 'edit'
  end

  def create
    @company_professional_tax = CompanyProfessionalTax.new(params[:company_professional_tax])
    @company_professional_tax.company = @company
    if @company_professional_tax.save
      flash[:notice] = t('professional_tax.messages.create')
      redirect_to :action => :show
    else
      render :action => :new
    end
  end

  def update
    if @company_professional_tax.update_attributes(params[:company_professional_tax])
      flash[:notice] = t('professional_tax.messages.update')
      redirect_to :action => :show
    else
      render :action => 'edit'
    end
  end

  def destroy
    @company_professional_tax.destroy
    redirect_to :action => :show
  end
  
  private

  def load_professional_tax
    @company_professional_tax ||= CompanyProfessionalTax.for_company(@company).first
  end
  
  concerned_calculators(:professional_tax)
end
