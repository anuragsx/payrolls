class PfForm12a
  extend ActiveSupport::Memoizable

  def initialize(company,salary_sheet)
    @salary_sheet = salary_sheet
    @company = company
    @presenter = SalarySheetPfPresenter.new(@company,@salary_sheet)
  end
  
  def pf_number
    CompanyPf.pf_number(@company)
  end
     
  def currency_period(date)
    "from #{date.beginning_of_financial_year.to_s(:date_month_and_year)} to #{date.end_of_financial_year.to_s(:date_month_and_year)}"
  end
     
  def statutory_rate
    CompanyPf.statutory_rate(@company)
  end
 
  def left_employees
    EmployeePension.joined_in_month(@salary_sheet.run_date).for_company(@company).count(:employee_id)
  end  

  def new_joining_employees
    EmployeePension.left_in_month(@salary_sheet.run_date).for_company(@company).count(:employee_id)
  end

  
  # Form 12A assistance view
  def generate_pf_form12a
    pdf = Prawn::Document.new(:page_layout => :landscape,
      :left_margin => 10, :right_margin => 10)
    pdf.font "Courier"
    pdf.font_size =10
    pdf.header [0,500] do
      stef = "#{RAILS_ROOT}/public/images/pf_logo.JPG"
      pdf.image stef,:at=>[20,580],:width => 70,:height=>70
      pdf.text "Form-12A (Revised)", :align=>:center,:style => :bold, :size => 15
      pdf.move_down 10
      pdf.text "EMPLOYEES’ PROVIDENT FUND AND MISC, PROVISIONS ACT, 1952",
        :align=>:center,:style => :bold
      pdf.text "EMPLOYEES’ PENSION SCHEME [PARAGRAPH 20(4)]",
        :align=>:center,:style => :bold
      pdf.text "Only for Un-Exempted Establishments", :align=>:right
      pdf.text "(To be filled in by the EPFO)", :align=>:left
    end
    pdf.bounding_box [0,420], :width => 250 do
      pdf.text "Name and Address of the Establisher"
      pdf.table [[@company.name],[@company.complete_address]],:border => 0,:width => 200
      pdf.move_down 10
      pdf.text "Code No.: <b>#{pf_number}</b>"
    end
    pdf.bounding_box [250,410], :width => 350 do
      pdf.text "Currency Period: <b>#{currency_period(@salary_sheet.run_date)}</b>"
      pdf.move_down 20
      pdf.text "Statement of contribution for the month of <b>#{@salary_sheet.formatted_run_date}</b>"
      pdf.move_down 20
      pdf.text "Statutory rate of Contribution: <b>#{statutory_rate}%</b>"
    end
    pdf.bounding_box [600,410], :width => 180 do
      pdf.text "Establishment Status:"
      pdf.move_down 30
      pdf.text "Group Code:"
    end
    pdf.cell [0,320], :width => 70 ,:height => 70,
      :text => 'Particulars (1)',:align => :center,:vertical_padding => 10
    pdf.cell [70,320], :width => 100 ,:height => 70,:vertical_padding => 10,
      :text => 'Wages on which Contributions are payable (2)',:align => :center
    pdf.cell [170,320], :width => 150 ,:height => 35,
      :text => 'Amount of contribution (3)',:align => :center,:vertical_padding => 10
    pdf.cell [170,285], :width => 75 ,:height => 35,
      :text => 'Recovered From the Worker',:align => :center,:vertical_padding => 2
    pdf.cell [245,285], :width => 75 ,:height => 35,
      :text => 'Payable by Employer',:align => :center,:vertical_padding => 2
    pdf.cell [320,320], :width => 150 ,:height => 35,
      :text => 'Amount of contribution remitted (4)',:align => :center,:vertical_padding => 10
    pdf.cell [320,285], :width => 75 ,:height => 35,
      :text => 'Worker’s Share',:align => :center,:vertical_padding => 5
    pdf.cell [395,285], :width => 75 ,:height => 35,
      :text => 'Employer’s Share',:align => :center,:vertical_padding => 5
    pdf.cell [470,320], :width => 100 ,:height => 70,
      :text => 'Amount of Administrative Charges Due (5)',:align => :center,:vertical_padding => 10
    pdf.cell [570,320], :width => 100 ,:height => 70,
      :text => 'Amount of Administrative Charges remitted (6)',:align => :center,:vertical_padding => 10
    pdf.cell [670,320], :width => 100 ,:height => 70,
      :text => 'Date of Remittance (enclose triplicate copies of challan) (7)',:align => :center
    data = [['E.P.F. A/C No. 01',
        @presenter.total_base_charge,
        @presenter.total_employee_contribution,
        @presenter.total_employer_epf_contribution,
        @presenter.total_employee_contribution,
        @presenter.total_employer_epf_contribution,
        @presenter.pension_admin,
        @presenter.pension_admin,
        ""],
      ['PensionFund A/c N.10',
        @presenter.total_base_charge,
        'NIL',
        @presenter.total_employer_pf_contribution,
        'NIL',
        @presenter.total_employer_pf_contribution,
        'NIL','NIL',
        ""],
      ['D.L.I. A/C No. 21',
        @presenter.total_base_charge,
        'NIL',
        @presenter.pension_edli,
        'NIL',
        @presenter.pension_edli,
        @presenter.pension_inspection,
        @presenter.pension_inspection,
        ""]]
    pdf.table data,
      :border_style => :grid,
      :width => 780,
      :font_size=>9,
      :column_widths => { 0 => 70, 1 => 100, 2 => 75 ,3 => 75,
      4 => 75, 5 => 75, 6 => 100, 7 => 100, 8 => 100 }
    pdf.bounding_box [250,150], :width => 400 do
      pdf.text "Name & Address of the bank in which the amount is remitted: "
      pdf.text "#{@company.bank}"
    end
    subscribers ={}
    subscribers[:new_joining] = new_joining_employees
    subscribers[:left] = left_employees
    subscribers[:total] = @presenter.total_employees
    subscribers[:last_month]= subscribers[:total] + subscribers[:left] - subscribers[:new_joining]
    pdf.bounding_box [0,150], :width => 200 do
      pdf.text "Total No. of Employees"
      pdf.text "a) Contract : Nil"
      pdf.text "b) Rest : #{subscribers[:total]}"
      pdf.text "c) Total : #{subscribers[:total]}"
    end
    data = Array.new
    data << ["No. of subscribers as per last month",
              subscribers[:last_month],
              subscribers[:last_month],
              subscribers[:last_month]]
    data << ["No. of subscribers as (Vide Form5)",
              subscribers[:new_joining],
              subscribers[:new_joining],
              subscribers[:new_joining]]
    data << ["No. of subscribers left service (Vide Form 10)",
              subscribers[:left],
              subscribers[:left],
              subscribers[:left]]
    data << ["(Nett.) Total Number of subscribers",
              subscribers[:total],
              subscribers[:total],
              subscribers[:total]]
    pdf.table data,
      :headers => ["Details of Subscribers","E.P.F.","Pen. Fund","E.D.L.I."],
      :align_headers => :center,
      :header_color=>"dddddd",
      :border => 0,
      :border_style => :grid,
      :width => 500,
      :font_size=> 9,
      :border_color =>"a09d9d",
      :horizontal_padding => 3
    pdf.footer([510,25],:width => 250) do
      pdf.text "Signature of the Employer with official (Seal)"
    end
    pdf
  end

  
end

