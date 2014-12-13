class DepartmentsController < ApplicationController
  
  before_filter :load_department, :only => [:edit, :update, :destroy]

  # POST /departments
  # POST /departments.xml
  def create
    @department = @company.departments.build(params[:department])
    respond_to do |format|
      if @department.save
        flash[:notice] = t('department.messages.create')
        format.html { redirect_to departments_path }
        format.xml  { render :xml => @department, :status => :created, :location => @department }
      else
        format.html { render :action => :index }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /departments/1
  # PUT /departments/1.xml
  def update
    respond_to do |format|
      if @department.update_attributes(params[:department])
        flash[:notice] = t('department.messages.updated')
        format.html { redirect_to departments_path }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.xml
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to(departments_path) }
      format.xml  { head :ok }
    end
  end

  private

  def load_department
    @department = @company.departments.find(params[:id])
  end

end
