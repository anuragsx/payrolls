class FormD
  
  def initialize(company,start_date,end_date)
    @company= company
    @start_date = start_date.to_date
    @end_date = end_date.to_date
    @lwf_presenter = @company.salary_sheets.between_date(@start_date,@end_date).map{|s|SheetLwfPresenter.new(@company,s)}
    @lwf = LabourWelfare.find_by_zone(@company.address.try(:state))
  end

  def start_date
    @start_date.to_s(:date_month_and_year)
  end

  def total_employees
    @lwf_presenter.sum{|x|x.total_employees}
  end
  
  def total_employer_lwf_contribution
    @lwf_presenter.sum{|x|x.total_employee_lwf_contribution}
  end

  def total_employee_lwf_contribution
    @lwf_presenter.sum{|x|x.total_employer_lwf_contribution}
  end

  def end_date
    @end_date.to_s(:date_month_and_year)
  end
  
  def total_contiribution
    total_employer_lwf_contribution + total_employee_lwf_contribution
  end
  
  def generate_pdf
    pdf = Prawn::Document.new(:page_layout => :landscape)
    pdf.font "Courier"
    pdf.font_size =10
    pdf.header [0,560] do
      pdf.text "#{@lwf.zone.upcase} LABOUR  WELFARE RULES FORM D", :align=>:center,:style => :bold, :size => 15
      pdf.text "STATEMENT OF EMPLOYEES' AND EMPLOYER'S CONTRIBUTIONS", :align=>:center
      pdf.text "Contribution Card for Current Period From #{start_date} To #{end_date}", :align=>:center
    end
    pdf.move_down(50)
    data = [[" Name and Address of the Establishment ", @company.name],
      ["",@company.complete_address],
      ["Name of the Employer", @company.name],
      ["Total No Workers whose Name stands in Establishment Registered on #{end_date}",total_employees],
      ["Employees Contributions",total_employee_lwf_contribution],
      ["Employers Contributions",total_employer_lwf_contribution],
      ["Total of Items 4 and 5",total_contiribution],
      ["Contribution is sent by Bank Draft and Details there of",@company.bank.try(:name)]
    ]
    pdf.table data,
      :font_size => 10,
      :border_style => :grid,
      :border_color =>"a09d9d",
      :column_widths => {0 => 480, 1 => 220}
    pdf
  end

  
end
