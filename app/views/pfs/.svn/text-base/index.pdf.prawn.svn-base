pdf = Prawn::Document.new(:page_layout => :landscape,
                          :left_margin => 10, :right_margin => 10,:bottom_margin => 10)
pdf.font "Courier"
pdf.font_size =10
pdf.header [0,560] do
  pdf.text "Form-3A (Revised)", :align=>:center,:style => :bold, :size => 15
  pdf.move_up(10)
  pdf.text "Only for Un-Exempted Establishments", :font_size => 7, :align=>:left
  pdf.move_down(10)
  pdf.text "The Employees' Provident Fund Scheme, 1952  (Para 35 & 42) and The Employees' Pension Scheme, 1995  (Para 19)",
    :align=>:center,:style => :bold
  pdf.text "Contribution Card for Current Period From 1st April #{@this_year} To 31st March #{@this_year+1}", :align=>:center
end
pdf.bounding_box [0,500], :width => 500 do
  data = [["1","P.F.Account Number.:<b>#{@employee_pf.epf_number}</b>"],
  ["2","Name/Surname: <b>#{@employee.employee_name}</b>"],
  ["3","Father's/Husband's name:<b>#{@employee.care_of}</b>"],
  ["5","Satutory rate of P.F.Contribution: <b>#{@employee_pf.pf_type.effective_employee_percent}</b>"],
  ["6","Voluntary higher rate of employee's Contribution, if any <b>#{@employee_pf.vpf_amount || @employee_pf.vpf_percent }</b>"]
  ]
  pdf.table data,
    :font_size => 10,
    :border_width => 0,
    :width => 500,
    :vertical_padding => 4
end
pdf.bounding_box [520,500], :width => 250 do
  pdf.text "4. Name and Address of the Establisher"
  pdf.table [[@company.name],[@company.complete_address]],:border => 0,:width => 250,:border_color =>"a09d9d"
end
pdf.text "CONTRIBUTION",:at => [0,400]
count =0
data = (@slip_presenters.map do |presenter|
  count +=1
  [presenter.salary_slip.run_date.to_s(:short_month_and_year),
  presenter.total_base_charge,
  presenter.total_employee_contribution,
  presenter.total_employer_epf_contribution,
  presenter.total_employer_pf_contribution,'','','']
end) << ['Grand Total',@slip_presenters.sum(&:total_base_charge),@slip_presenters.sum(&:total_employee_contribution),
        @slip_presenters.sum(&:total_employer_epf_contribution),@slip_presenters.sum(&:total_employer_pf_contribution),'','','']
pdf.move_down(60)
pdf.table data,
  :headers => ['Month',"Worker's Amount of Wages","Worker's E.P.F.",
               "Employer's E.P.F.","Employer's Pension Fund","Refund of Advances",
               'No.of days/period of non-contributing service(if any)',"Remark"],
  :font_size => 10,
  :border_style => :grid,
  :column_widths => {0 => 100, 1 => 100, 2 => 100, 3 => 100,
                     4 => 70, 5 => 70,6 => 100 ,7 => 120},
  :vertical_padding => 2,
  :border_color =>"a09d9d"

pdf.move_down(20)
pdf.text "Certified that the total amount of contribution (both shares) indicated in this Card i.e. Rs.  0 /- has already  been remitted",:size => 9
pdf.text "in full in EPF A/c  No.1 and Pension Fund A/c No. 10  Rs.  0  ( vide note below )",:size => 9
pdf.move_down(5)
pdf.text "Certified that the difference between the total of the contribution shown under the columns 3 & 4a & 4b of the above table and",:size => 9
pdf.text "that arrived at on the total wages shown in column 2 at the prescribed rate is solely due to rounding off of contributions to the nearest ruopee under the rules.",:size => 9
pdf.move_down(10)
pdf.text "Date",:style => :bold,:align => :left
pdf.move_up(10)
pdf.text "Signature of the Employer with Office Seal",:style => :bold,:align => :right
pdf.move_down(10)
pdf.text "<b>Notes :</b> (1) In respect of the form 3A sent to the Regional Office during the course of the current period for the purpose",:size => 9
pdf.text "            of final settlement of the accounts of the member who has left service,details of date and reason  for leaving service should",:size => 9
pdf.text "            be furnished under col. 7(a) & (b).",:size => 9
pdf.text "        (2)In respect of those who are not members of the Pension Fund the Employers share of contribution to be EPF will be 8.1/3%",:size => 9
pdf.text "           or 10% as the case may be & is to be shown under column 7(a).",:size => 9


