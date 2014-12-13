class TaxDetailsController < ApplicationController

  before_filter :load_tax_detail

  def show
    respond_to do |format|
      if @tax_detail.blank?
        flash[:notice] = t('tax.messages.tax_detail.set')
        format.html  do
          redirect_to new_employee_tax_details_path and return
        end
      else
        format.html do
          @investment_for_current_fy = EmployeeInvestment80c.for_employee(@employee).for_financial_year(Date.today.financial_year).sum(:amount)
          @active_fix_amount_deduction = EmployeeTax.for_employee(@employee).last.try(:amount) || 0
          @other_incomes_for_current_fy = EmployeeOtherIncome.for_employee(@employee).for_financial_year(Date.today.financial_year).sum(:amount)
        end
        format.pdf do
          pdf = Form16.new(@company,Date.today.financial_year,@employee,@tax_detail).download_form16
          send_data(pdf.render, :filename => company_file_name(:action => 'Form16', :duration => params[:year]))
        end
      end
      format.xml  { render :xml => @tax_detail }
      format.json { render :json => @tax_detail}
    end
  end

  def new
    @tax_detail = EmployeeTaxDetail.new
    render :action => :edit
  end
    
  def create
    @tax_detail = EmployeeTaxDetail.new(params[:employee_tax_detail])
    @tax_detail.company = @company
    @tax_detail.employee = @employee
    if @tax_detail.save
      flash[:notice] = t('tax.messages.tax_detail.created')
      redirect_to employee_tax_details_path(@employee)
    else
      render :action => :edit
    end
  end

  def update
    if @tax_detail.update_attributes(params[:employee_tax_detail])
      flash[:notice] = t('tax.messages.tax_detail.updated')
      redirect_to employee_tax_details_path(@employee)
    else
      render :action => :edit
    end
  end

  def destroy
    @tax_detail.destroy
    redirect_to :action=>:show
  end

  private
  def load_tax_detail
    @tax_detail ||= EmployeeTaxDetail.for_employee(@employee).first
  end

end