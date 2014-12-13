class Form5a

  def initialize(company,sheet)
    @@professional_tax_head ||= SalaryHead.code_for_professional_tax
    @company = company
    @salary_sheet = sheet
    @company_pt = CompanyProfessionalTax.for_company(@company).first
    @info =ActiveSupport::OrderedHash.new
    @total_employee = 0
    @total_taxes = 0.0
    @toal_amount = 0.0
    ProfessionalTaxSlab.for_zone(@company_pt.zone).each do |pt|
      @info[pt] = {:min => pt.salary_min,
        :max => pt.salary_max,
        :tax_amount => 0.0,
        :employees => 0,
        :amount => 0.0
      }
      charges = @salary_sheet.salary_slip_charges.under_head(@@professional_tax_head).for_reference(pt).compact
      @total_employee += @info[pt][:employees] = charges.map{|c|c.employee}.uniq.size
      @toal_amount += @info[pt][:amount] = charges.sum(&:amount).abs
      @total_taxes += @info[pt][:tax_amount] = pt.tax_amount
    end
  end
  
  def salary_sheet
    @salary_sheet
  end
  
  def info
    @info.values
  end

  def total_employee
    @total_employee
  end

  def total_taxes
    @total_taxes
  end

  def total_amount
    @toal_amount
  end

  def download_pdf
    pdf = Prawn::Document.new
    pdf.font "Courier"
    pdf.font_size 10
    pdf.text "Form 5A", :size => 15, :align => :center, :style => :bold
    pdf.text "Professional Tax Annual Return", :align => :center
    pdf.text "RETURN OF TAX PAYABLE BY EMPLOYER UNDER SUB-SECTION(1) OF SECTION 6-A OF THE  #{@company_pt.zone.try(:upcase)} TAX ON PROFESSION, TRADE, CALLINGS AND EMPLOYMENT ACT 1976", :align => :center
    pdf.move_down(10)
    pdf.table [['Return of tax payable for the year ending on',''],
      ['Name of the employer',@company.name],
      ['Address',@company.complete_address],
      ['Registration Certificate No.',''],
      ['PTO Circle No.','']
    ],
      :font_size => 10,
      :border_width => 0,
      :column_widths => {0 =>  300, 1 => 270},
      :vertical_padding => 3
    pdf.move_down(10)
    data = info.map {|p|[info.index(p)+1,"#{p[:min]} and #{p[:max]}", p[:employees],p[:tax_amount],p[:amount]]}
    data << [{:text => "Total",:colspan => 2}, total_employee, total_taxes, total_amount]
    data << [{:text =>"Add : Simple interest payable (if any)  on the above amount at two percent per month or part thereof ( vide section II (2) of the Act ).",:colspan =>2},'','','']
    data << [{:text => "Grand",:colspan => 2}, total_employee, total_taxes, total_amount]
    pdf.table data,
      :headers => ["#","Employees whose monthly salaries or wages or both","No. of  Employees",
      "Rate of Tax", " Amount of Tax  Deducted"],
      :border_style => :grid,
      :font_size => 10,
      :column_widths => {0 => 25, 1 => 200, 2 => 110,3=> 110,4=>110},
      :border_color =>"a09d9d",
      :header_color=>"dddddd",
      :vertical_padding => 2
    pdf.table [['Name of the Bank:',''],
      ['Amount paid by cheque no.',''],
      ['Dated',''],
      ['Ruppes',total_amount] ],
      :font_size => 10,
      :border_width => 0,
      :column_widths => {0 =>  300, 1 => 270},
      :vertical_padding => 3,
      :align => :left
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
