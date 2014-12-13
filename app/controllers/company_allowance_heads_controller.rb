class CompanyAllowanceHeadsController < CalculatorController

  before_filter :load_company_allowances

  def index
    @all_allowances = SalaryHead.allowance_compatible
    @selected = @allowance_heads.collect{|ca| ca.salary_head}
    @not_selected = @all_allowances - @selected
  end

  def create
    @allowance_heads.each{|d|d.delete}
    if params[:salary_head]
      CompanyAllowanceHead.bulk_create(params[:salary_head],@company)
    end
    respond_to do |format|
      format.js {head :ok}
      format.html do
        flash[:notice] = t('heads.messages.created')
        redirect_to :action => :index
      end
    end
  end
  
  protected

  def load_company_allowances
    @allowance_heads = CompanyAllowanceHead.for_company(@company).all
  end

  concerned_calculators(:simple_allowance,:flexible_allowance)

end