class PfForm10

  def initialize(company,salary_sheet)
    @salary_sheet = salary_sheet
    @company = company
    @company_code = CompanyPf.pf_number(@company)
    @employees ={}
    EmployeePension.left_in_month(@salary_sheet.run_date).for_company(@company).each do |emp|
      @employees[emp] ||= {:account_no => emp.epf_number,
                                :name => emp.employee.name.upcase,
                                :left_date => emp.deleted_at.to_s(:date_month_and_year),
                                :exit_reason => emp.exit_reason,
                                :care_of => emp.employee.employee_detail.try(:care_of)
                                }
    end
  end
  
  def employees
    @employees.values
  end
  
  def print_form10
    pdf = Prawn::Document.new(:page_layout => :landscape,
      :left_margin => 10, :right_margin => 10)
    pdf.font "Courier"
    pdf.font_size =10
    pdf.bounding_box [0,560], :width => 780 do
      pdf.text "FORM No.10", :align=>:center, :style => :bold, :size => 15
      pdf.move_down 10
      pdf.text "The Employees'Provident Fund Scheme,1952",
        :align=>:center,:style => :bold
      pdf.text "Paragaraph 36(2)(a) and(b)",
        :align=>:center,:style => :bold
      pdf.text "Employees'Pension Scheme,1995",
        :align=>:center,:style => :bold
      pdf.text "Paragaraph 20(4)",
        :align=>:center,:style => :bold
    end
    pdf.text "Return of Members Leaving Service During The Month of <b>#{@salary_sheet.formatted_run_date}</b>",:at => [0,450]
    pdf.bounding_box [0,430], :width => 350 do
      pdf.text "Name and Address of the Establisher"
      pdf.move_down 5
      pdf.text @company.name,:style => :bold
      pdf.text @company.complete_address, :style => :bold
    end
    pdf.bounding_box [500,430], :width => 280 do
      pdf.text "Code No. of the Establishment: <b>#{@company_code}</b>"
    end
    pdf.move_down 40
    headers =["#","Account No.","Name of the Member <br/>(in block letters)",
      "Father’s Name or Husband’s Name(incase of married women)","Date of leaving Service",
      "*Reasons for leaving service <br/>(See note given bellow)","Remarks"]
    index= 0
    data = @employees.values.map do |emp|
      [index+=1,emp[:account_no],emp[:name],emp[:care_of],emp[:left_date],emp[:exit_reason],'']
    end
    pdf.table data,
      :headers => headers,
      :align_headers => :center,
      :border_style => :grid,
      :width => 760,
      :font_size=> 9,
      :column_widths => {0 => 50, 1 => 60, 2 => 150,
      3 => 170 , 4 => 70, 5 => 150, 6 => 100},
      :align => {0 => :center, 1 => :center, 2 => :left, 3 => :left,
      4 => :center, 5 => :center, 6 => :center}
    pdf.move_down(20)
    pdf.text "NOTE: Please state the member is"
    pdf.text "(a) Retiring (b) leaving India for permanent settlement aboard"
    pdf.text "(c) Retrenchment"
    pdf.text "(d) Permanent & total disablement due to employment injury"
    pdf.text "(e) Discharged "
    pdf.text "(f) Resigning from or leaving service"
    pdf.text "(g) Taking up employment elsewhere,(Then  name and address of the employer should be stated)"
    pdf.text "(h) Dead &(i)attained age of 58 years."
    pdf.footer([450,10],:width =>300) do
      pdf.text "Signature of the Employer or other authorised officer or stamp of the Factory/Establishment "
    end
    pdf
  end
end

