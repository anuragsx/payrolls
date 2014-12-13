class ApplicationController < ActionController::Base
  protect_from_forgery


  helper :all # include all helpers, all the time
  helper ApplicationHelper
  include SubdomainCompany, Presenter
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :check_account_status, :set_default_url_options_for_mailers, :set_locale
  before_filter :current_employee, :current_sheet#, :login_or_oauth_required
  #after_filter  :check_email_activation
  helper_method :current_user_session, :current_user


  protected

  def check_email_activation
    if current_user
      flash[:error] = t('user_session.unverified') if !current_user.try(:activate?)
    end
  end

  def check_account_status
    # TODO: this is where we could check to see if the account is active as well (paid, etc...)
    unless account_subdomain == default_account_subdomain
      if account_subdomain == "signup"
        redirect_to new_package_account_url(Package.last.name) if params[:package_id].blank?
      else
        redirect_to default_account_url and return if current_account.nil?
      end
    end
  end

  def set_locale
    session[:locale] = params[:locale] || session[:locale] || I18n.default_locale
    I18n.locale = session[:locale]
    I18n.load_path += Dir[ File.join(Rails.root, 'config ', 'locales', '*.{rb,yml}') ]
  end

  # Scrub sensitive parameters from your log
  #TODO
  #filter_parameter_logging :password, :password_confirmation

  def set_default_url_options_for_mailers
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    user_session = UserSession.find
    # TODO REFACTOR IN FUTURE WITH A BETTER WAY
    unless user_session.nil?
      if user_session && user_session.user.try(:company).try(:subdomain) == 'admin'
        @current_user_session = user_session
      else
        @current_user_session = current_account && current_account.user_sessions.find.user
      end
      @current_user_session
    end
  end
=begin
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    user = UserSession.find
    unless user.nil?
      sess = user.user
      @current_user_session = user
    end
  end
=end
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session# && current_user_session.record
  end

  def require_no_user
    logger.debug "ApplicationController::require_no_user"
    if current_user
      store_location
      #flash[:notice] = "You must be logged out to access this page"
      # redirect_to home_index_path
      redirect_to home_path and return
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
=begin
  def require_user
    logger.debug "ApplicationController::require_user"
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end
=end
  def require_user
    unless current_user
      store_location
      if ["xml","json"].include?(params[:format])
        request_http_basic_authentication
      else
        flash[:notice]="You must be logged in to access this page"
        redirect_to new_user_session_url
      end
    end
  end
  alias_method :login_required,:require_user

=begin

  def current_user
    return @current_user if !@current_user.nil?
    @current_user = current_user_session && current_user_session.user
  end


  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end


  def require_user
    unless current_user
      store_location
      if ["xml","json"].include?(params[:format])
        request_http_basic_authentication
      else
        flash[:notice]="You must be logged in to access this page"
        redirect_to new_user_session_url
      end
    end
  end
  alias_method :login_required,:require_user

  def authorized?
    true
  end

  def require_no_user
    if current_user
      store_location
      redirect_to home_path and return
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
=end
  def destroy_session!
    session = UserSession.find
    session.destroy if session
    redirect_to new_user_session_path
  end

  def current_employee
    @employee = @company.employees.find(params[:employee_id]) if params[:employee_id]
  end

  def current_sheet
    if params[:salary_sheet_id]
      @salary_sheet = @company.salary_sheets.for_month(Date.parse(params[:salary_sheet_id])).first
    end
  end

  def read_financial_year
    @this_year = params[:year].try(:to_i) || Date.today.financial_year
    @prev_year = @this_year - 1
    @next_year = @this_year + 1
    @fy_start = Date.financial_year_start(@this_year)
  end

  def read_calendar_year
    @this_year = params[:year].try(:to_i) || Date.today.year
    @prev_year = @this_year - 1
    @next_year = @this_year + 1
  end

  def load_salary_sheet
    date = Date.parse(params[:id])
    @salary_sheet = @company.salary_sheets.for_month(date).first
    unless @salary_sheet
      flash[:error] = "No Salary Sheet exists for the month of #{date.to_s(:short_month_and_year)}"
      redirect_to salary_sheets_path
    end
  end

  def check_no_salary_sheet_exists
    @date = begin Date.parse(params[:salary_sheet_id]) rescue nil end
    unless @date
      flash[:error] = "Unable to determine Salary Sheet dates"
      redirect_to salary_sheets_path
    else
      sheet = @company.salary_sheets.for_month(@date).first
      if sheet
        flash[:error] = "Salary Sheet for #{@date.to_s(:for_param)} already billed"
        redirect_to salary_sheet_path(sheet)
      end
    end
  end

  def group_salary_sheets
    year = @this_year || Date.today.financial_year
    @salary_sheets = @company.salary_sheets.in_fy(year).index_by{|s| s.run_date.month}
  end

  def company_file_name(options={})
    options.reverse_merge!({:title => controller_name.singularize,
                            :action => params[:action],
                            :duration => '',
                            :ext => params[:format]})
    [@company.subdomain,options[:title],options[:action],options[:duration]].compact.map{|x|x.downcase.gsub(/\s/,'_')}.join("_")+".#{params[:format]}"
  end















end
