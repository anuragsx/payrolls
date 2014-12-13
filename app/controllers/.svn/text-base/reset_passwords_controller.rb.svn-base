class ResetPasswordsController < ApplicationController

  layout 'user_sessions'
  
  skip_before_filter :login_or_oauth_required
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice]= t('reset_password.password_email')
      redirect_to root_url
    else
      flash[:notice]= t('reset_password.no_user')
      render :action => :new
    end
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice]= t('reset_password.updated')
      redirect_to company_path(@company)
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
     flash[:notice]= t('reset_password.wrong_perishable_token')
      redirect_to root_url
    end
  end
 
end
