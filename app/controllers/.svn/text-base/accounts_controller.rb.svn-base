class AccountsController < ApplicationController

  layout 'sign_up'

  before_filter :load_user_using_perishable_token, :only => [:activate]
  before_filter :require_no_user, :only => [:new, :create]
  skip_before_filter :current_employee
  skip_before_filter :login_or_oauth_required, :only => [:new, :activate, :create, :check_subdomain, :welcome ]
  skip_before_filter :check_account_status, :only => [:new, :create, :check_subdomain]

  def new
    if @company && current_user
      flash[:error] = t('users.messages.already_logged_in')
      redirect_back_or_default(root_url) and return
    end
    @package = Package.find_by_name(params[:package_id])
    unless @package
      flash[:error] = t('users.messages.select_package')
      redirect_back_or_default(root_url) and return
    end
    @user = User.new
    @company = @user.build_company
    @address = @user.build_address
  end

  def create
    @package = Package.find_by_name(params[:package_id])
    @company = Company.new(params[:company])
    @user = @company.owner
    @company.package = @package
    @user.activate = false
    if @company.update_attributes(params[:company]) && create_defaults
      @company.find_owner.deliver_email_verification_instructions!
      reset_session
      flash[:notice] = "User account successfully created. Please Enter your password to access your account."
      redirect_to root_url(:subdomain => @company.subdomain)
    else
      flash[:error] = t('users.messages.error_registering')
      render :action => :new
    end
  end

  def welcome
    render :layout => 'user_sessions'
  end

  def activate
    @user.activate = true
    if @user.save
      flash[:notice] = "User account successfully verified. Please Enter your password to access your account."
      unless @company.owner
        redirect_to edit_reset_password_path(@user.perishable_token)
      else
        redirect_to root_url
      end
    else
      redirect_to welcome_accounts_path
    end
  end

  def check_subdomain
    subdomain = params[:subdomain].downcase
    data = {:status => "error", :message => "available"}
    if $subdomain_exclusion.include?(subdomain)
      data[:message] = "reserved"
    elsif subdomain !~ /^[A-Za-z0-9-]+$/
      data[:message] = "not valid"
    elsif subdomain.size < 3
      data[:message] = "too short"
    elsif subdomain.size > 20
      data[:message] = "too long"
    elsif Company.find_by_subdomain(subdomain)
      data[:message] = "not available"
    else
      data[:status] = "available"
    end
    render :inline => data.to_json
  end

  def resend_email
    UserMailer.deliver_email_verification_instructions(current_user)
    flash[:notice] = "Email sent successfully. Please check your email."
    redirect_to :back
  end

  private

  def load_user_using_perishable_token
    reset_session!
    @user = @company.users.find_by_perishable_token(params[:code])
    unless @user
      flash[:error] = ("We're sorry, but we could not locate your account. " +
          "If you are having issues try copying and pasting the URL " +
          "from your email into your browser or restarting the " +
          "account activation process.")
      redirect_to welcome_accounts_path
    end
  end

  def create_defaults
    #sends events to the respective model
    flag = @company.departments.create(:name => "#{@company.name} HQ")
    flag1 = CompanyPf.create(:company => @company)
    flag2 = CompanyEsi.create(:company => @company)
    flag3 = CompanyLeave.create(:company => @company)
    flag4 = create_default_calculators
    flag5 = create_default_salary_heads
    (flag && flag1 && flag2 && flag3 && flag4 && flag5)
  end

  def create_default_calculators
    @defaults = ["LeaveAccountingCalculator", "SimpleAllowanceCalculator",
                "AdvanceCalculator","EsiCalculator","PfCalculator",
                "BonusCalculator","LoanCalculator", "IncomeTaxCalculator"]
    @defaults.each_with_index do |calc,i|
      @company.transaction do
        begin
          @company.company_calculators.create(:calculator => Calculator.find_by_type(calc), :position =>i+1 )
        rescue Exception => err
          logger.error("Error processing Registration #{err.message}")
          return false
        end
      end
    end
    true
  end

  def create_default_salary_heads
    @defaults = ["medical","rent","conveyance", "special_allowance"]
    @defaults.each_with_index do |head, i|
      @company.transaction do
        begin
          CompanyAllowanceHead.create(:salary_head => SalaryHead.find_by_code(head), :position => i+1,:company => @company)
        rescue Exception => err
          logger.error("Error processing Registration #{err.message}")
          return false
        end
      end
    end
    true
  end

  def reset_session!
    session = UserSession.find
    session.destroy if session
  end

end