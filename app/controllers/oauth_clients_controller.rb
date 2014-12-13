class OauthClientsController < ApplicationController
  before_filter :get_client_application, :only => [:show, :edit, :update, :destroy]
  
  def index
    @client_applications = current_user.client_applications.for_company(@company)
    @tokens =  {}
    @client_applications.each do |c|
      @tokens[c] = c.tokens.for_user(current_user).validate_token
    end
  end

  def new
    @client_application = current_user.client_applications.for_company(@company).new
  end

  def create
    @client_application = current_user.client_applications.build(params[:client_application])
    @client_application.company = @company
    if @client_application.save
      flash[:notice] = "Registered the information successfully"
      redirect_to :action => "show", :id => @client_application.id
    else
      render :action => "new"
    end
  end
  
  def show
  end

  def edit
  end
  
  def update
    if @client_application.update_attributes(params[:client_application])
      flash[:notice] = "Updated the client information successfully"
      redirect_to :action => "show", :id => @client_application.id
    else
      render :action => "edit"
    end
  end

  def destroy
    @client_application.destroy
    flash[:notice] = "Destroyed the client application registration"
    redirect_to :action => "index"
  end
  
  private
  def get_client_application
    unless @client_application = ClientApplication.for_company(@company).find(params[:id])
      flash.now[:error] = "Wrong application id"
      raise ActiveRecord::RecordNotFound
    end
  end
end
