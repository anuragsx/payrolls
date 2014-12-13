class CompanyGradesController < ApplicationController

  before_filter :load_grades, :only => [:edit, :update, :destroy]
  
  def index
    @company_grades = @company.company_grades
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @company_grades }
    end
  end

  def new
    render :action => "edit"
  end
  
  def create
    @company_grade = @company.company_grades.build(params[:company_grade])

    respond_to do |format|
      if @company_grade.save
        flash[:notice] = 'CompanyGrade was successfully created.'
        format.html { redirect_to company_grades_path}
        format.xml  { render :xml => @company_grade, :status => :created, :location => @company_grade }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company_grade.errors, :status => :unprocessable_entity }
      end
    end
  end

 
  def update   
    respond_to do |format|
      if @company_grade.update_attributes(params[:company_grade])
        flash[:notice] = 'CompanyGrade was successfully updated.'
        format.html { redirect_to company_grades_path}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company_grade.errors, :status => :unprocessable_entity }
      end
    end
  end

 
  def destroy    
    @company_grade.destroy

    respond_to do |format|
      format.html { redirect_to(company_grades_url) }
      format.xml  { head :ok }
    end
  end

  private

  def load_grades
   @company_grade = @company.company_grades.find(params[:id])
  end
end
