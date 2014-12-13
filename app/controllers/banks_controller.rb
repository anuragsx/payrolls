class BanksController < ApplicationController
 
  before_filter :set_vars, :except => [:new, :create]
  
  def show    
    if @bank.blank?
      flash[:notice] = t('bank.messages.set_bank')
      redirect_to new_bank_path and return
    end
    render
  end

  def new    
    @bank = Bank.new
    @address = @bank.build_address
    respond_to do |format|
      format.html {render :action => 'edit'}
      format.xml  { render :xml => @bank }
    end
  end
  
  def edit    
  end

  def create
    @bank = Bank.new(params[:bank])
    @bank.company = @company       
    if @bank.save
      flash[:notice] = t('bank.messages.created')
      redirect_to bank_path
    else
      render :action => 'edit'
    end
  end

  def update    
    respond_to do |format|
      if @bank.update_attributes(params[:bank])
        flash[:notice] = t('bank.messages.updated')
        format.html { redirect_to bank_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bank.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy    
    @bank.destroy
    redirect_to new_bank_path and return
  end

  private
  def set_vars
    @bank ||= Bank.find_by_company_id(@company)
  end
  
end
