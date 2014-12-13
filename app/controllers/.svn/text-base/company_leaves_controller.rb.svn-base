class CompanyLeavesController < CalculatorController

  before_filter :load_company_leave, :except=>[:create, :new]

  def show
    if @company_leave.blank?
      flash[:notice] = t('leaves.messages.set')
      redirect_to new_company_leave_path
    end
  end
  
  def new
    @company_leave = CompanyLeave.new
    @company_leave.company = @company
    render :action => :edit
  end
  
  def create
    @company_leave = CompanyLeave.new(params[:company_leave])
    @company_leave.company = @company
    if @company_leave.save
      flash[:notice] = t('leaves.messages.create')
      redirect_to company_leave_path
    else
      flash[:error] = t('leaves.messages.error_creating')
      render :action => :edit
    end
  end
  
  def update
    if @company_leave.update_attributes(params[:company_leave])
      flash[:notice] = t('leaves.messages.update')
      redirect_to company_leave_path
    else
      flash[:error] = t('leaves.messages.error_updating')
      render :action => :edit
    end
  end

  def forward_leaves
    from_year = params[:from_year]
    to_year = params[:to_year]
    if from_year.to_i < to_year.to_i
      @company_leave.send_later(:carry_forward_leave_balances!,from_year.to_i,to_year.to_i)
      flash[:notice] = t('leaves.messages.being_carried_forward')
    else
      flash[:error] = t('leaves.messages.wrong_parameter')
    end
    redirect_to company_leave_path
  end

  private
  
  def load_company_leave
    @company_leave = CompanyLeave.scoped_by_company_id(@company).first
  end

  concerned_calculators(:leave_accounting)

end