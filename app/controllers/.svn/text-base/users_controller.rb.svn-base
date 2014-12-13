class UsersController < ApplicationController

  def index
    @users = @company.users
    respond_to do |format|
      format.html
      format.xml {render :xml => @users}
      format.json {render :json => @users}
    end
  end

  def new
    @user = User.new
    @address =  @user.address || @user.build_address
  end

  def edit
    @user = @company.users.find(params[:id])
    @address =  @user.address || @user.build_address
  end

  def create
    @user = User.new(params[:user])
    @user.company = @company
    if @user.save
      flash[:notice] = t('users.created')
      redirect_to users_path
    else
      flash[:error] = t('users.error_creating')
      render :action => "new"
    end
  end

  def update
    @user = @company.users.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = t('users.updated')
      redirect_to users_path
    else
      flash[:error] = t('users.error_updating')
      render :action => :edit
    end
  end

  def swap_user_status
    @user = User.find(params[:id])
    if @user != @current_user
      status = !@user.activate?
      if @user.update_attribute(:activate, status)
        flash[:notice] = t('users.updated')
      end
    else
      flash[:error] = t('users.cant_deactivate_self')
    end
    redirect_to users_path
  end

  def send_email
    @user = User.find(params[:id])    
    UserMailer.deliver_user_welcome(@user)
    respond_to do |format|
      flash[:notice] = t('users.email_sent')
      format.html { redirect_to users_path }
      format.xml  { head :ok }
    end
  end

  def destroy
    @user = User.find(params[:id])
    respond_to do |format|
      if @user != @current_user
        #@user.destroy
        flash[:notice] = t('users.destroyed')
        format.html { redirect_to users_path }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        flash[:error] = t('users.cant_destroy_self')
        format.html { redirect_to users_path }
        format.xml  { head :ok }
        format.json { head :ok }
      end
    end    
  end
end
