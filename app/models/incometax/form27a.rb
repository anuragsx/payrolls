class Form27a
  extend ActiveSupport::Memoizable
  attr_accessor :add_annexure_form
  
  def initialize(company,tds_return)
    @date_of_depotise = tds_return.tax_deposited_date.try(:to_s,:date_month_and_year)
    @date_of_deduction = tds_return.tax_deduction_date.try(:to_s,:date_month_and_year)
    @company = company
    @tds_return = tds_return
    @start_date =  tds_return.start_date
    @end_date = tds_return.start_date.end_of_quarter
    @fy_year = @start_date.year
    @next_year = @start_date.next_year.year
    @tds_details ={}
    @tds_return.employee_tds_returns.each do |etds|
      @tds_details[etds.employee] = EmployeeIncomeTaxPresenter.new(@company,etds.employee,@start_date,@end_date)
    end
  end

  def start_date
    @start_date.try(:to_s,:date_month_and_year)
  end

  def end_date
    @end_date.try(:to_s,:date_month_and_year)
  end
  
  def add_annexure_form
    return true if @end_date.end_of_month == @end_date.end_of_financial_year
  end

  def annual_tds_detail
    @annual_tds_detail ={}
    @tds_return.employee_tds_returns.each do |etds|
      employee = etds.employee
      @annual_tds_detail[employee] = Form16.new(@company,@fy_year,employee,EmployeeTaxDetail.for_employee(employee).first)
    end
    @annual_tds_detail
  end
  memoize :annual_tds_detail

  def tds_details
    @tds_details.values
  end
  memoize :tds_details
  
  def total_taxable_amount
    tds_details.sum(&:taxable_amount)
  end

  def total_tax_on_income
    tds_details.sum(&:tax_on_income)
  end
  
  def surcharge_amount
    tds_details.sum(&:surcharge)
  end

  def edu_cess_amount
    tds_details.sum(&:edu_cess)
  end
  
  def total_deducted_tax
    tds_details.sum(&:deducted_tax)
  end
  memoize :total_deducted_tax
  
  def total_dedutee
    @tds_return.employee_tds_returns.size
  end

  def interest_amount
    @tds_return.intrest_amount || 0.0
  end
  memoize :interest_amount

  def total_amount_deposite
    total_deducted_tax + interest_amount
  end
  
  def download_from_27a
    pdf = Prawn::Document.new(:page_size => "A4",:right_margin => 10,:left_margin => 10)
    pdf.font "Courier"
    pdf.font_size =10
    pdf.bounding_box [0,790],:width => 580 do
      pdf.text "FORM No.27A", :align=>:center,:style => :bold
      pdf.text "[ See rule 37B]",:align=>:center,:style => :bold
      pdf.text "Form for furnishing information with the statement of deduction/collection of tax at source(thick whichever is appicable)filled on computer media for the period from #{start_date} to #{end_date}"
    end
    data = [["1. (a) Tax Deduction Account Number","<b>#{@company.tan}</b>","   (c) Financial year","<b>#{@fy_year.formatted_fy}</b>"],
      ["   (b) Permanent Account Number","<b>#{@company.pan}</b>","   (d) Assessment Year","<b>#{@next_year.formatted_fy}</b>"],
      ["   (c) Form no.","<b>24Q</b>","   (f) Previous receipt number",""]
    ]
    pdf.table data,
      :border_width => 0,
      :font_size => 10,
      :vertical_padding => 3,
      :column_widths => {0 => 220,1=>70,2 => 200,3 => 90}
    pdf.move_down(10)
    pdf.text "2. Particulars of deductor/collector"
    deductor_data = [[" (a) Name","<b>#{@company.name}</b>"],[" (b) Type of deductor",""],
      [" (c) Branch/division (if any)",""],[" (d) Address",""],
      ["    Flat No.","<b>#{@company.address.try(:address_line1)}</b>"],["    Name of the premises/building","<b>#{@company.address.try(:address_line2)}</b>"],
      ["    Road/street/lane","<b>#{@company.address.try(:address_line3)}</b>"],["    Area/location",""],
      ["    Town/City/District","<b>#{@company.address.try(:city)}</b>"],["    State","<b>#{@company.address.try(:state)}</b>"],
      ["    Pin code","<b>#{@company.address.try(:pincode)}</b>"],
      ["    Telephone No.","<b>#{@company.address.try(:mobile_number)}</b>"], ["    Email",""]
    ]
    pdf.table deductor_data,
      :border_width => 0,
      :font_size => 10,
      :vertical_padding => 3,
      :ailgn => :center,
      :column_widths => { 0 => 280, 1 => 300 }
    pdf.move_down(10)
    pdf.text "3. Name of the person responsible for deduction/collection of tax"
    deductor_data = [[" (a) Name",""],[" (b) Address",""],
      ["     Flat No.",""],["     Name of the premises/building",""],
      ["     Road/street/lane",""],["     Area/location",""],
      ["     Town/City/District",""],["     State",""],["     Pin code",""],
      ["     Telephone No.",""], ["     Email",""]
    ]
    pdf.table deductor_data,
      :border_width => 0,
      :font_size => 10,
      :vertical_padding => 3,
      :width => 580
    pdf.move_down(10)
    pdf.text "4. Control totals"
    pdf.table [[total_dedutee,total_taxable_amount,total_deducted_tax,total_deducted_tax]] ,
      :headers => ["No. of deductee/ party records","Amount paid",
      "Tax deducted/collection","Tax deposited (Total challan amount)"],
      :border_width => 1,
      :font_size => 10,
      :border_style => :grid,
      :width => 580,
      :border_color =>"a09d9d",
      :align_headers => :center,
      :vertical_padding => 3
    pdf.move_down(10)
    pdf.text "5. Total Number of Annexures enclosed"
    pdf.move_down(10)
    pdf.text "6. Other Information"
    pdf.move_down(20)
    pdf.text "Verification",:align => :center
    pdf.move_down(10)
    pdf.text "I, __________________ , hereby certify that all the particulars furnished above are correct and complete."
    pdf.table [["","Name and Signature of person responsible for"],
      ["Place: ____________","deducting tax at source"],["Date : ____________","Designation"]],
      :border_width => 0,
      :font_size => 10,
      :width => 580,
      :vertical_padding => 3,
      :column_widths => { 0 => 300, 1 => 280 }
    pdf.start_new_page(:layout => :landscape,:right_margin => 10,:left_margin => 10)
    pdf.text "FORM NO. 24Q", :align=>:center,:style => :bold
    pdf.text "(See section 192 and rule 31A)",:align=>:center,:style => :bold
    pdf.text "Quarterly statement of deduction of tax under sub-section (3) of section 200 of the Income-tax Act, 1961 in respect of salary for the quarter ended #{start_date}"
    pdf.text "_"*140
    form_24_data = [
      ["1.(a) Tax Deduction Account No.","<b>#{@company.tan}</b>"],["  (b) Permanent Account No.","<b>#{@company.pan}</b>"],
      ["  (c) Financial year","<b>#{@fy_year.formatted_fy}</b>"],["  (d) Assessment year","<b>#{@next_year.formatted_fy}</b>"],["  (e) Has any statement been filed earlier for this quarter (Yes/No)",""],
      ["  (f) If answer to (e) is ‘Yes’, then Provisional Receipt No. of original statement",""],
      ["2. Particulars of the deductor (employer)",""],["  (a) Name","<b>#{@company.name}</b>"],["  (b) Type of deductor1",""],["  (c) Branch/Division (if any)",""],
      ["  (d) Address",""],["    Flat No.","<b>#{@company.address.try(:address_line1)}</b>"],["    Name of the premises/building","<b>#{@company.address.try(:address_line2)}</b>"],["    Road/street/lane","<b>#{@company.address.try(:address_line3)}</b>"],
      ["    Area/location",""],["    Town/City/District","<b>#{@company.address.try(:city)}</b>"],["    State","<b>#{@company.address.try(:state)}</b>"], ["    Pin code","<b>#{@company.address.try(:pincode)}</b>"],["    Telephone No.","<b>#{@company.address.try(:mobile_number)}</b>"],["   E-mail",""],
      ["3. Particulars of the person responsible for deduction of tax",""],["  (a) Name",""],["  (b) Address",""],["    Flat No.",""],["    Name of the premises/building",""],["    Road/street/lane",""],
      ["    Area/location",""],["    Town/City/District",""],["    State",""], ["    Pin code",""],["    Telephone No.",""],["    E-mail",""],
    ]
    pdf.table form_24_data,
      :border_width => 0,
      :font_size => 10,
      :column_widths => {0 => 600,1=>170}
    pdf.text "4. Details of tax deducted and paid to the credit of Central Government ?"
    pdf.move_down(10)
    tax_detail = []
    tax_detail << ["(301)","(302)","(303)","(304)","(305)","(306)","(307)","(308)","(309)","(310)","(311)","(312)"]
    tax_detail << ["1",total_tax_on_income,surcharge_amount,edu_cess_amount,interest_amount,"",total_amount_deposite,"#{@tds_return.cheque_ya_dd_no}","#{@tds_return.bsr_code}",
      "#{@date_of_depotise}","#{@tds_return.challan_serial_no}",""]
    tax_detail << ["Total",total_tax_on_income,surcharge_amount,edu_cess_amount,interest_amount,"",total_amount_deposite,"","","","",""]
    pdf.table tax_detail,
      :headers => ["#","TDS Amount","Surcharge (Rs.)","Education Cess (Rs.)","Interest (Rs.)","Others (Rs.)","Deposited (Rs.)",
      "Cheque/DD No. (if any)","BSR code","Date on which tax deposited","Transfer voucher/  Challan serial No.2","Whether TDS deposited by book entry? Yes/No3"],
      :border_width => 1,
      :font_size => 8,
      :border_style => :grid,
      :border_color =>"a09d9d",
      :align_headers => :center,
      :vertical_padding => 3,
      :column_widths => { 0 => 40, 1 => 60,2 => 60,3=>80,4 =>50,5=>50,6=>100,7=>100,8=>60,9=>100,10=>60,11=>60 }
    pdf.move_down(10)
    pdf.text "5. Details of salary4 paid and tax deducted thereon from the employees [(i) Enclose Annexure I along with each quarterly statement
        having details for the relevant quarter; (ii) Enclose Annexure II along with the last quarterly statement, i.e., for the quarter
        ending 31st March, having the details for the whole Financial Year"
    pdf.move_down(20)
    pdf.text "Verification",:align => :center
    pdf.move_down(10)
    pdf.text "I, __________________ , hereby certify that all the particulars furnished above are correct and complete."
    pdf.table [["","Name and Signature of person responsible for"],
      ["Place: ____________","deducting tax at source"],["Date : ____________","Designation"]],
      :border_width => 0,
      :font_size => 10,
      :width => 580,
      :vertical_padding => 3,
      :column_widths => { 0 => 300, 1 => 280 }
    pdf.start_new_page(:layout => :landscape,:right_margin => 10,:left_margin => 10)
    pdf.text "ANNEXURE I", :align=>:center,:style => :bold
    pdf.text "Deductee wise break-up of TDS",:align=>:center,:style => :bold
    annexure1_data = [
      ["Details of salary paid and tax deducted thereon from the employees",""],["BSR code of the branch where tax is deposited","<b>#{@tds_return.bsr_code}</b>"],
      ["Date on which tax deposited","<b>#{@date_of_depotise}</b>"],["Challan Serial No.","<b>#{@tds_return.challan_serial_no}</b>"],["Section under which payment made","<b>#{@tds_return.payment_made}</b>"],
      ["Total TDS to be allocated among deductees as in the vertical total of Col. 323","<b>#{total_deducted_tax}"],
      ["Interest","<b>#{interest_amount}</b>"],["Others","<b>0</b>"],["Total of the above","<b>#{total_amount_deposite}"],["Name of Employer","<b>#{@company.name}</b>"],
      ["TAN","<b>#{@company.tan}</b>"] ]
    pdf.table annexure1_data,
      :border_width => 0,
      :font_size => 10,
      :column_widths => {0 => 600,1=>170}
    annexure1_tax_detail = []
    annexure1_tax_detail << ["(313)","(314)","(315)","(316)","(317)","(318)","(319)","(320)","(321)","(322)","(323)","(324)","(325)","(326)"]
    @tds_details.values.each_with_index do |presenter,i|
      annexure1_tax_detail << [i,presenter.reference_no,presenter.pan,presenter.name,@date_of_deduction,presenter.taxable_amount,
        presenter.tax_on_income,presenter.surcharge,presenter.edu_cess,presenter.deducted_tax,presenter.deducted_tax,"",@date_of_depotise,@date_of_deduction]
    end
    annexure1_tax_detail << ["","","","Total","",total_taxable_amount,total_tax_on_income,surcharge_amount,edu_cess_amount,total_deducted_tax,@total_tax,"","",""]
    pdf.table annexure1_tax_detail,
      :headers => ["#","Employee reference No.provided by employer","PAN of the employee","Name of the employee","Date of payment/ credit",
      "Taxable amount or which tax deducted","TDS","Surcharge","Education Cess (Rs.)","Total Tax Deducted (Rs.)","Deposited (Rs.)",
      "Date of deduction","Date of deposit","Reason for nondeduction/ lower deduction*"],
      :border_width => 1,
      :font_size => 8,
      :border_style => :grid,
      :border_color =>"a09d9d",
      :align_headers => :center,
      :vertical_padding => 3,
      :column_widths => { 0 => 40, 1 => 60,2 => 60,3=>80,4 =>50,5=>50,6=>80,7=>50,8=>60,9=>60,10=>60,11=>60,12=> 60, 13=>60}
    pdf.move_down(20)
    pdf.text "Verification",:align => :center
    pdf.move_down(10)
    pdf.text "I, __________________ , hereby certify that all the particulars furnished above are correct and complete."
    pdf.table [["","Name and Signature of person responsible for"],
      ["Place: ____________","deducting tax at source"],["Date : ____________","Designation"]],
      :border_width => 0,
      :font_size => 10,
      :width => 580,
      :vertical_padding => 3,
      :column_widths => { 0 => 300, 1 => 280 }
    if add_annexure_form
      pdf.start_new_page(:layout => :landscape,:right_margin => 10,:left_margin => 10)
      pdf.text "ANNEXURE II", :align=>:center,:style => :bold
      pdf.text "Details of salary paid/credited during the Financial Year #{@fy_year.formatted_fy} and net tax payable",:align=>:center,:style => :bold
      annexure2_tax_detail1 =[]
      annexure2_tax_detail1 << ["(327)","(328)","(329)","(330)","(331)","","(332)","(333)","(334)","(335)"]
      annexure2_tax_detail2 = []
      annexure2_tax_detail2 << ["","(336)","(337)","(338)","(339)","(340)","(341)","(342)","(343)","(344)","(345)","(346)","(347)"]
      annual_tds_detail.values.each_with_index do |presenter,i|
        annexure2_tax_detail1 << [i+1,presenter.employee_pan,presenter.employee_name,presenter.tax_category,presenter.joing_date,end_date,presenter.gross_total_income,"0",presenter.gross_total_income,presenter.any_other_income]
        annexure2_tax_detail2 << [i+1,presenter.total_employee_income,presenter.employee_investments_80c[:deductible_amount],"0",presenter.employee_investments_80c[:deductible_amount],
          presenter.total_taxable_income,presenter.total_tax_on_income,0.0,presenter.total_edu_cess,0.0,presenter.total_tds,0.0,presenter.total_tds]
      end
      pdf.table annexure2_tax_detail1,
        :headers => ["#","PAN of the employee","Name of the employee","Write ‘W’ for woman, ‘S’ for senior citizen and ‘G’ for others",
        "Date from which employed with current employer","Date To","Total amount of salary (See note 4 appearing at the end of the main Form)",
        "Total deduction under section 16(ii) and 16(iii) (specify each deduction separately)",
        "Income chargeable under the head “Salaries” (Column 332 minus 333)","Income (including loss from house property) under any head other than the head “Salaries” offered for TDS [section 192(2B)]"],
        :border_width => 1,
        :font_size => 8,
        :border_style => :grid,
        :border_color =>"a09d9d",
        :align_headers => :center,
        :vertical_padding => 3,
        :column_widths => { 0 => 40, 1 => 100,2 => 100,3=>80,4 =>70,5=>70,6=>80,7=>50,8=>100,9=>100}
      pdf.move_down(10)
      pdf.table annexure2_tax_detail2,
        :headers => ["#","Gross total income (Total of columns 334 and 335)","Aggregate amount of deductions under sections 80C, 80CCC and 80CCD (Total to be limited to amount specified in section 80CCE)",
        "Amount deductible under any other provision(s) of Chapter VI-A","Total Amount deductible under Chapter VI-A (Total of columns 337 and 338)","Total taxable income (columns 336 minus column 339)","Total tax – (i) income-tax on total income","(ii) surcharge","(iii) Education Cess (Rs.)",
        "Income tax Relief under section 89, when salary etc., is paid in arrear or in advance","Net tax payable  (columns 341 +342+343-344)",
        "Total amount of tax deducted at source for the whole year [aggregate of the amount in column 322 of Annexure I for all the four quarters in respect of each employee]",
        "Shortfall in tax deduction(+)/  Excess tax deduction(-) [column 345 minus column 346]"],
        :border_width => 1,
        :font_size => 8,
        :border_style => :grid,
        :border_color =>"a09d9d",
        :align_headers => :center,
        :vertical_padding => 3,
        :column_widths => { 0 => 40, 1 => 80,2 => 80,3=>80,4 =>60,5=>60,6=>80,7=>50,8=>60,9=>60,10=>60,11=>60,12=> 60}
      pdf.move_down(20)
      pdf.text "I, __________________ , hereby certify that all the particulars furnished above are correct and complete."
      pdf.table [["","Name and Signature of person responsible for"],
        ["Place: ____________","deducting tax at source"],["Date : ____________","Designation"]],
        :border_width => 0,
        :font_size => 10,
        :width => 580,
        :vertical_padding => 3,
        :column_widths => { 0 => 300, 1 => 280 }
    end
    pdf
  end
  
end
