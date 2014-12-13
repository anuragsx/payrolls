class LabourWelfaresController < CalculatorController

  before_filter :read_financial_year, :only => [:index]
  before_filter :load_salary_sheet, :only => [:show]
  
  def index
    respond_to do |format|
      if @employee
        @lwf_presenters = @employee.salary_slips.in_fy(@this_year).map{|c|SlipLwfPresenter.new(c)}
        format.html{ render :template=> "labour_welfares/employee_lwf" }
      else
        format.html do
          @count = LabourWelfare.find_by_zone(@company.address.try(:state)).try(:submissions_count)
          @lwf_presenters = @company.salary_sheets.in_fy(@this_year).map{|s|SheetLwfPresenter.new(@company,s)}
        end
        format.pdf do
          read_date(params[:period])
          pdf = FormD.new(@company,@start_date,@end_date).generate_pdf
          send_data(pdf.render,:file_name => company_file_name(:action => "form_d",:duration => params[:period] ))
        end
      end
    end
  end
  
  def show
    @presenter = SheetLwfPresenter.new(@company,@salary_sheet)
  end


  private
  
  def read_date(period)
    if (period =~ /(H.) (\d\d\d\d)/)
      date = Date.financial_year_start($2.to_i)
      @start_date =  date.send('beginning_of_financial_'+$1.downcase)
      @end_date = date.send('end_of_financial_'+$1.downcase)
    elsif (period =~ /(Q.) (\d\d\d\d)/)
      date = Date.financial_year_start($2.to_i)
      @start_date =  date.send('beginning_of_financial_'+$1.downcase)
      @end_date = date.send('end_of_financial_'+$1.downcase)
    elsif (period =~ /(Y)(\d\d\d\d)/)
      date = Date.financial_year_start($2.to_i)
      @start_date =  date
      @end_date = date.send('end_of_financial_year')
    else
      date = period.to_date
      @start_date =  date.beginning_of_month
      @end_date = date.end_of_month
    end
  end

end
