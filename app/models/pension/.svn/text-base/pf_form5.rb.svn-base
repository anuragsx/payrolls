class PfForm5
  
  def initialize(company,salary_sheet)
    @salary_sheet = salary_sheet
    @company = company
    @company_code = CompanyPf.pf_number(@company)
    @employees ={}
    EmployeePension.joined_in_month(@salary_sheet.run_date).for_company(@company).each do |emp|
      @employees[emp] ||= {:account_no => emp.epf_number,
        :name => emp.employee.name.upcase,
        :joining_date => emp.created_at.to_s(:date_month_and_year),
        :dob => emp.employee.employee_detail.try(:date_of_birth),
        :care_of => emp.employee.employee_detail.try(:care_of),
        :sex => emp.employee.sex
      }
    end
  end
 
  def employees
    @employees.values
  end
  
  def print_form5
    pdf = Prawn::Document.new(:page_layout => :landscape,
      :left_margin => 10, :right_margin => 10)
    pdf.font "Courier"
    pdf.font_size 10
    pdf.bounding_box [0,560], :width => 780 do
      pdf.text "FORM No.5", :align=>:center, :style => :bold, :size => 15
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
    pdf.bounding_box [0,460], :width => 780 do
      pdf.text "Return of Employees qualifying for membership of the Employees’ Provident Fund,"
      pdf.move_down 5
      pdf.text "Employees Pension Fund & Employees’ Deposit Linked Insurance Fund for the first time during the month of #{@salary_sheet.formatted_run_date}"
      pdf.move_down 5
      pdf.text "(To be sent to the Commissioner with Form 2 (EPF & EPS) "
    end
    pdf.bounding_box [0,400], :width => 350 do
      pdf.text "Name and Address of the Establisher"
      pdf.move_down 5
      pdf.text @company.name,:style => :bold
      pdf.text @company.complete_address, :style => :bold
    end
    pdf.bounding_box [500,400], :width => 280 do
      pdf.text "Code No. of the Establishment: <b>#{@company_code}</b>"
    end
    pdf.move_down 40
    headers =["#","A/c No.","Name of Employee <br/>(in block letters)",
      "Father’s Name or Husband’s Name (incase of married women)","Date of Birth","Sex","Date of joining the Fund",
      "Total period of previous service as on the date of joining the Fund <br/>(Enclose Scheme certificate if applicable)"," Remarks "]
    index = 0
    data = @employees.values.map do |emp|
      [index+=1,emp[:account_no],emp[:name],emp[:care_of],emp[:dob],emp[:sex],emp[:joining_date],'','']
    end
    pdf.table data,
      :headers => headers,
      :align_headers => :center,
      :border_style => :grid,
      :width => 760,
      :font_size=> 9,
      :column_widths => {0 => 30, 1 => 60, 2 => 150,
      3 => 150 , 4 => 50, 5 => 50, 6 => 100, 7 => 130,8 => 50 },
      :align => {0 => :center, 1 => :center, 2 => :left, 3 => :left,
      4 => :center, 5 => :center, 6 => :center, 7 => :center, 8 => :center}
    pdf.footer([450,10],:width =>300) do
      pdf.text "Signature of the Employer or other authorised officer or stamp of the Factory/Establishment "
    end
    pdf
  end
end

