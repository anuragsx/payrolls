class GratuitiesController < ApplicationController

  before_filter :read_financial_year, :only => :index
  before_filter :load_salary_sheet, :only => :show

  def index
    respond_to do |format|
      format.html do
        @salary_sheet_presenters = @company.salary_sheets.in_fy(@this_year).map{|s|SalarySheetGratuityPresenter.new(@company,s)}.group_by{|x|x.run_date.financial_year}
      end
    end
  end

  def show
    @presenter = SalarySheetGratuityPresenter.new(@company,@salary_sheet)
    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        return prawn_generated_gratuties_pdf
      end
    end
  end

end
