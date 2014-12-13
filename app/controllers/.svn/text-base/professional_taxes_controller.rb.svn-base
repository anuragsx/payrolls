class ProfessionalTaxesController < ApplicationController
  
  before_filter :read_financial_year, :only => [:index,:show]
  
  def index
    if @salary_sheet      
      respond_to do |format|
        format.html do
          @company_pt = CompanyProfessionalTax.for_company(@company).first
          @presenter =SalarySheetPtPresenter.new(@company,@salary_sheet)
          render :action => 'sheet_view'
        end
        format.pdf do
          pdf = Form5a.new(@company,@salary_sheet).download_pdf
          send_data(pdf.render, :filename => company_file_name(:action => 'From5A',:duration => @salary_sheet.run_date.to_s(:short_month_and_year)), :type => 'application/pdf')
        end
      end
    else      
      respond_to do |format|
        format.html do
          @presenters = @company.salary_sheets.in_fy(@this_year).map{|s|SalarySheetPtPresenter.new(@company,s)}
        end
        format.pdf do
          pdf = Form5.new(@company,@this_year).download_pdf
          send_data(pdf.render, :filename => company_file_name(:action => 'From5',:duration => @this_year.to_s), :type => 'application/pdf')
        end
      end
    end
  end
  
  def show
    @professional_tax ||= EmployeeProfessionalTax.for_employee(@employee).first
    @zone = CompanyProfessionalTax.for_company(@company).first.try(:zone)
    @slip_presenters = @employee.salary_slips.in_fy(@this_year).map{|s|SlipPtPresenter.new(s)}  
  end

  def deregister
    @professional_tax = EmployeeProfessionalTax.for_employee(@employee).first
    if @professional_tax
      @professional_tax.destroy
      flash[:notice] = t('professional_tax.messages.deregistered')
    else
      EmployeeProfessionalTax.create(:employee => @employee, :company => @company)
      flash[:notice] =  t('professional_tax.messages.registered')
    end
    redirect_to :action => :show
  end
  
end
