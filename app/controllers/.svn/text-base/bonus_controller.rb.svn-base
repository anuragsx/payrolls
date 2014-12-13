class BonusController < CalculatorController

  def index
    if @employee
      respond_to do |format|
        format.html  do
          @bonuses = BonusCalculator.find_bonus_for_employee(@employee).group_by{|c| c.financial_year}
          @given = CompanyBonus.for_company(@company)
          render :template=>"bonus/employee_bonuses"
        end
        format.xml  { render :xml => BonusCalculator.find_bonus_for_employee(@employee) }
        format.json { render :json => BonusCalculator.find_bonus_for_employee(@employee)}
      end
    else
      @bonuses = BonusCalculator.find_bonus_for_company(@company).group_by{|c| c.financial_year}
      @total = {}
      @bonuses.each {|k,v| @total[k] = v.sum(&:amount)}
    end
  end

  def show
    params[:id] ||= Date.today.year
    @bonuses = BonusCalculator.find_bonus_for_company(@company,params[:id])
    @given = CompanyBonus.for_company(@company)
    respond_to do |format|
      format.html
      format.pdf do
        @prawnto_options = {:filename => company_file_name(:action => 'register', :duration => params[:year]), :inline => false}
      end
      format.xls do
        @excel = {:filename => company_file_name(:action => 'register', :duration => params[:year]), :layout => false}
      end
    end
  end

  def  list_all
    @company_bonus = CompanyBonus.for_company(@company).all
  end

  def settings
    @company_bonuses = CompanyBonus.for_company(@company).all
    @company_bonus = CompanyBonus.new()
  end

  def create
    @company_bonus = CompanyBonus.new(params[:company_bonus])
    @company_bonus.company = @company
    if @company_bonus.save
      flash[:notice] = t('bonus.messages.create')
      redirect_to settings_bonus_path
    else
      render :action => 'settings'
    end
  end
  
end
