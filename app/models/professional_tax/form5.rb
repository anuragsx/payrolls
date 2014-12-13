class Form5

  def initialize(company,year)
    @company = company
    @company_pt= CompanyProfessionalTax.for_company(@company).first
    @this_year = year
    @presenters = @company.salary_sheets.in_fy(@this_year).map{|s|SalarySheetPtPresenter.new(@company,s)}
  end

  def download_pdf
    pdf = Prawn::Document.new
    pdf.font "Courier"
    pdf.font_size 10
    pdf.text "Form 5", :size => 15, :align => :center, :style => :bold
    pdf.text "Professional Tax Annual Return", :align => :center
    pdf.text "RETURN OF TAX PAYABLE BY EMPLOYER UNDER SUB-SECTION(1) OF SECTION 6-A OF THE #{@company_pt.zone.try(:upcase)} TAX ON PROFESSION, TRADE, CALLINGS AND EMPLOYMENT ACT 1976", :align => :center
    pdf.move_down(10)
    pdf.table [["","Name of the A.P.T.O Circle Number",""],
               ['1.','Return of tax payable for the year ending on',''],
               ['2.','Name of the employer',@company.name],
               ['3.','Address',@company.complete_address],
               ['4.','Registration Certificate No.',''],
               ['5.','Tax paid during the year is as under','']
              ],
         :font_size => 10,
         :border_width => 0,
         :column_widths => {0 => 30, 1 => 250, 2 => 270}
    pdf.move_down(10)
    pdf.table @presenters.map {|p|[@presenters.index(p)+1,p.salary_sheet.run_date.to_s(:short_month_and_year),
                                  p.grand_total_pt,'','','']},
              :headers => ["#","Month","Tax Deduction","Tax Paid",
                          "Balance Tax","Paid under Challan No. & Date"],
              :border_style => :grid,
              :font_size => 10,
              :column_widths => {0 => 25, 1 => 100, 2 => 100,3=> 100,4=>100,5 => 130},
              :border_color =>"a09d9d",
              :header_color=>"dddddd"
    pdf.move_down(10)
    pdf.table [["6.","Total Tax payable for the year ending:",""],
               ['7.','Tax paid as per monthly statament:',@presenters.sum(&:grand_total_pt)],
               ['2.','Balance tax payable:',''],
               ['3.','Balance tax paid under challan No. date:',''],
              ],
         :font_size => 10,
         :border_width => 0,
         :column_widths => {0 => 25, 1 => 250, 2 => 70}
    pdf.move_down(10)
    pdf.text "I Certify that all the employees who are liable to pay the tax in my employment during the period of return have been covered by the foregoing particular. I also certify that"
    pdf.text "the necessary revision in the amount of tax deductable from the salary or wages of the employess on account of variation in the salary of wages earned by them has been made where necessary."
    pdf.move_down(10)
    pdf.text "I #{@company.name} solemnly declare that the above statement are true to the best of my knowledge and belief."
    pdf.move_down(30)
    pdf.text "Place:",:align => :left
    pdf.text "Date:",:align => :left
    pdf.move_up(20)
    pdf.text "Signature:                         ",:align => :right
    pdf.text "Employer Status:                   ",:align => :right
    pdf
  end
  
end
