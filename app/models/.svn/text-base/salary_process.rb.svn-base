include Presenter
class SalaryProcess 
    
  def self.salary_sheet_generator(salary_sheet)
    @presenter = SalarySheetPresenter.new(salary_sheet.company,salary_sheet)
    # temp file
    file_name = "public/#{salary_sheet.company.subdomain}-Salary-Sheet-for-#{@presenter.month_date}.pdf"
    # generate salary sheet pdf
    prawn_generated_salary_sheet_pdf(file_name)
    attached_pdf_to_model(salary_sheet,file_name)
  end
    
  def self.salary_slip_generator(slip)
    @presenter = SalarySlipPresenter.new(slip)
    # temp file
    file_name = "public/#{slip.company.subdomain}-Slip-#{@presenter.employee.name}-for-#{@presenter.month_date}.pdf"
    # generate salary slip pdf
    prawn_generated_salary_slip_pdf(file_name)
    attached_pdf_to_model(slip,file_name)
  end
     
  private
      
    
  def self.attached_pdf_to_model(obj,attached_file)
    f = File.open(attached_file,'r')
    obj.doc = f
    f.close
    obj.save
    File.delete(attached_file) if File.exist?(attached_file)
  end
   

end
