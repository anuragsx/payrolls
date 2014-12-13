class EsiForm5
  def initialize(company,start_date)
    @@employee_head ||= SalaryHead.code_for_employee_esi
    @@employer_head ||= SalaryHead.code_for_employer_esi
    @start_date = start_date
    @end_date = (@start_date + 6.months) - 1.day
    @company = company
    @esi_code_number = CompanyEsi.for_company(@company).first.try(:esi_number)
    @place = @company.address.try(:city)
    @total_employee_contribution = 0.0
    @total_employer_contribution = 0.0
    @total_amount_deposted = 0.0
    @total_wages = 0.0
    @challan_detail = ActiveSupport::OrderedHash.new
    current_date = @start_date
    while current_date.month <= @end_date.month
      @total_employee_contribution+= amount = SalarySlipCharge.for_company(@company).under_head(@@employee_head).for_month(current_date).sum('amount').abs
      @total_employer_contribution+= eper_amount = SalarySlipCharge.for_company(@company).under_head(@@employer_head).for_month(current_date).sum('amount')
      @challan_detail[current_date.to_s(:month_and_year)] = {:amount => amount + eper_amount,
                                                             :bank => @company.bank.name }
      current_date = current_date.next_month
    end
    @total_amount_deposted += @total_employee_contribution + @total_employer_contribution
    @esi_employees = {}
    EmployeeEsi.for_company(@company).each do |es|
      @esi_employees[es] ={
        :name => es.employee.employee_name,
        :number => es.esi_number,
        :total_days => 0.0,
        :total_wages => 0.0,
        :employee_contribution => 0.0,
        :daily_wages => 0.0,
        :continue_service => ''
      }
      charges = SalarySlipCharge.for_company(@company).for_employee(es.employee).under_head(@@employee_head).between_date(@start_date,@end_date)
      charges.each do |charge|
        @esi_employees[es][:total_days] += charge.salary_sheet.month_length * charge.salary_slip.leave_ratio
        @esi_employees[es][:total_wages] += charge.base_charge
        @esi_employees[es][:employee_contribution] += charge.amount.abs
      end
      unless @esi_employees[es][:total_days] == 0.0 && @esi_employees[es][:total_days] == 0
        @esi_employees[es][:daily_wages] = (@esi_employees[es][:total_wages] / @esi_employees[es][:total_days]).round(2)
      end
      @total_wages += @esi_employees[es][:total_wages]
    end
 end

  def esi_employees
    @esi_employees.values
  end
  
  
  def generate_form_5
    pdf = Prawn::Document.new(:page_size => "A4")
    pdf.font "Times-Roman"
    pdf.font_size =10
    pdf.bounding_box [0,780], :width => 540 do
      pdf.text "FORM 5", :align=>:center,:style => :bold
      pdf.move_down(20)
      pdf.text "Name of Local Office:#{@company.complete_address}",:at => [0,750]
      pdf.text "Employer’s Code Number:#{@esi_code_number}",:at=>[380,750]
      pdf.text "RETURN OF CONTRIBUTIONS",:align=>:center,:style => :bold
      pdf.text "( In quadruplicate )", :align=>:center
      pdf.text "[Regulation 26]", :align=>:center
    end
    pdf.bounding_box [0,710], :width => 540 do
      data = [["Name of the Establisher",@company.name],
        ["Address of the Establisher",@company.complete_address],
        [{:text => "Particulars of the principal employer:-",:colspan => 2,:font_size => 8}],
        [{:text => '(a)	Name'},''],
        [{:text => '(b)	Designation'},''],
        [{:text => 'c)	Residential address'},'']]
      pdf.table data,
        :border_width => 0,
        :border_color =>"a09d9d",
        :font_size => 9,
        :cloumn_widths => {0=>80,1=>460}
      pdf.move_down(5)
      pdf.text "Contribution Period : From  #{@start_date.to_s(:month_and_year)}  To  #{@end_date.to_s(:month_and_year)}",:align => :left
    end
    pdf.bounding_box [0,560], :width => 540 do
      pdf.text "I furnish below the details of the employer’s share of contributions in respect of the" + 
        "undermentioned insured persons.I hereby declare that the return includes every employee,employed"+
        "directly or through an immediate employer or in connection with the work of the factory / establishment"+
        "or purchase of raw materials, sale or distribution of finished products,etc.to whom the contribution"+
        "period to which this return relates, applies and that the contributions in respect of employer’s and"+
        "employee’s share have been correctly paid in connection with the provisions of the Act and regulations relating to the payment of contributions, vide challans detailed below:",
        :size => 9
    end
    pdf.bounding_box [100,500], :width => 440 do
      pdf.table [['Employer’s share',@total_employee_contribution],
        ['Employee’s share',@total_employer_contribution],
        [{:text => 'Total contribution',:font_style => :bold},@total_amount_deposted]],
        :border_width => 0,
        :border_color =>"a09d9d",
        :font_size => 10,
        :cloumn_widths => {0=>80,1=>320},
        :vertical_padding => 1
    end
    pdf.bounding_box [0,450], :width => 540 do
      pdf.text "Detail Of Challans :-"
      sn = 0
      data = @challan_detail.map do|key,value|
        [sn+=1,key,'',value[:bank],value[:amount]]
      end
      data << [{:text => 'Total Amount Deposited',:colspan => 4,:font_style => :bold},{:text => "#{@total_amount_deposted}", :font_style => :bold}]
      pdf.table data,
        :headers => ['#','Month','Date Of Deposited Challan','Name Of Bank & Brance','Amount'],
        :header_color=>"dddddd",
        :font_size => 10,
        :border_color =>"a09d9d",
        :border_width =>1,
        :border_style => :grid,
        :column_widths => {0 => 20,1 => 120,2=>120,3=>120,4=>120,5=>120},
        :align => {0 => :left, 1 => :left, 2 => :center, 3 => :left, 4 => :right}
    end
    pdf.move_down(50)
    pdf.text "Place:",:align => :left
    pdf.move_down(5)
    pdf.text "Date:",:align => :left
    pdf.text "Authorized Signature", :align => :right
    pdf.bounding_box [0,180], :width => 540 do
      pdf.text "Important instructions "
      pdf.move_down(5)
      pdf.text "1.	If any I.P. is appointed for the first time and / or leaves service during the contribution period, indicate “A…….(date)” and / or “L……..(date)”, in the remarks column (No.8).",:size => 9
      pdf.move_down(2)
      pdf.text "2. (Please indicate the name of the dispensary to which the insured person is attached in the case of new entrants and if there is change in the name of the dispensary indicate name of new dispensary in the remarks column.)",:size => 9
      pdf.move_down(2)
      pdf.text "3.	Please indicate insurance numbers in chronological ascending order.", :size => 9
      pdf.text "4.	Figures in columns 4,5 and 6 shall be in respect of wage periods ended during the contribution period.", :size => 9
      pdf.text "5.	Invariably strike totals of columns 4, 5 and 6 of the return.", :size => 9
      pdf.text "6.	No overwriting shall be made.  Any corrections should be signed by the employer.", :size => 9
      pdf.text "7.	Every page of this return should have full signature and rubber stamp of the employer.", :size => 9
      pdf.text "8.	‘Daily wages’ in column 7 of the return shall be calculated by dividing figures in column 5 by figures in column 4, to two decimal places.", :size => 9
    end
    pdf.start_new_page
    pdf.bounding_box [0,780], :width => 540 do
      pdf.text "FORM 5", :align=>:center,:style => :bold
      pdf.move_down(20)
      pdf.text "Name of the Establisher:#{@company.name}",:align=>:left
      pdf.text "Employer’s Code Number:#{@esi_code_number}",:align=>:left
      pdf.move_up(20)
      pdf.text "Period from #{@start_date.to_s(:month_and_year)} to #{@end_date.to_s(:month_and_year)}",:align=>:right
    end
    pdf.move_down(20)
    index=0
    data = @esi_employees.values.map {|v|[index +=1 , v[:number],v[:name], v[:total_days],
        v[:total_wages], v[:employee_contribution], v[:daily_wages], v[:continue_service],'']}
    data << [{:text => "Total",:colspan => 4},@total_wages,@total_employee_contribution,'','','']
    pdf.table data,
      :headers => ['#','Insurance No.','Name of Insured Person','Total days',
      'Total wages',"Employees’ contribution",
      'Daily wages','Continue Service','Remarks'],
      :header_color=>"dddddd",
      :font_size => 10,
      :border_color =>"a09d9d",
      :align_headers => :center,
      :border => 0,
      :border_style => :grid,
      :width => 540,
      :column_widths => {0 => 20,1 => 70, 2 => 100, 3 => 50,
      4 => 70, 5 => 70, 6 => 50, 7 => 50, 8 => 50}
    pdf.move_down(50)
    pdf.text "Signature",:align => :right
    pdf 
  end
end

