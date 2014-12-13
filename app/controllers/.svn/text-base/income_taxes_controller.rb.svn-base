class IncomeTaxesController < ApplicationController

   before_filter :read_financial_year, :only => [:index]
   before_filter :load_salary_sheet, :only => [:show]

  def slabs
    @slabs = TaxSlab.order_by_financial_year.group_by{|e| e.tax_category.category}
  end

  def tds_challan
    pdf = TdsChallan.new(@company,@salary_sheet).generate_tds_challan
    send_data(pdf.render, :filename => company_file_name(:duration => @salary_sheet.formatted_run_date), :type => 'application/pdf')
  end

  def index
    @salary_sheet_presenters = @company.salary_sheets.in_fy(@this_year).group_by{|ss| ss.run_date.financial_half}
  end

  def show
    @presenter = SalarySheetIncomeTaxPresenter.new(@company, @salary_sheet)
    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        @prawnto_options = {:filename => company_file_name(:action => 'register'), :inline => false}
      end
    end
  end

end
