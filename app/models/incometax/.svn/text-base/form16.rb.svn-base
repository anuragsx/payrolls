require "erb"
include ERB::Util
class Form16
  extend ActiveSupport::Memoizable
  def initialize(company,year,employee,tax_detail)
    @@income_tax_head ||= SalaryHead.code_for_tds
    @company = company
    @employee = employee
    @fy_year = year
    @tax_detail = tax_detail
    @gorss_salary ={}
    @exempt_amount ={}
    salary_charges.group_by(&:salary_head).each do |key,charges|
      @gorss_salary[key.name] = charges.sum(&:amount).abs
      @exempt_amount[key.name] = charges.sum(&:exempt_amount).abs
    end
    @total_tds_charges = SalarySlipCharge.under_head(@@income_tax_head).in_fy(@fy_year).for_employee(@employee).sum(:amount)
  end
  
  def gross_salary
    @gorss_salary.delete_if{|key,value| value == 0}
  end
  
  def exempt_amount
    @exempt_amount.delete_if{|key,value| value == 0}
  end
  
  def total_gross
    @gorss_salary.values.sum
  end
  memoize :total_gross
  
  def total_exempt_amount
    @exempt_amount.values.sum
  end
  memoize :total_exempt_amount

  def gross_total_income
    total_gross - total_exempt_amount
  end
  memoize :gross_total_income
  
  def tax_category
    name = @tax_detail.tax_category.try(:category)
    unless name.nil?
      case name
      when "Females"; return "W"
      when "Males"; return "G"
      when "Senior Citizen(Over 65)"; return "S"
      end
    end
  end
  
  def joing_date
    @employee.commencement_date.to_s(:date_month_and_year)
  end

  
  def employee_investments_80c
    tds_info = {:gross_amount => 0.0,:schemes => {} }
    EmployeeInvestment80c.for_employee(@employee).for_financial_year(@fy_year).map do |e|
      tds_info[:schemes][e.employee_investment_scheme.name]= e.amount
      tds_info[:gross_amount] += e.amount
    end
    EmployeeInvestment80c.salary_investments(@employee, @fy_year.financial_months.last.end_of_month).map do |c|
      tds_info[:schemes][c.salary_head.short_name]= c.amount.abs
      tds_info[:gross_amount]+=c.amount.abs
    end
    tds_info[:deductible_amount] = EmployeeInvestment80c.eligible_amount_invested(tds_info[:gross_amount])
    tds_info
  end
  memoize :employee_investments_80c
  
  
  def designation
    current_package.try(:designation)
  end
  
  def employee_pan
    @tax_detail.try(:pan)
  end
  
  def employee_name
    @employee.employee_name
  end
  
  def total_tds
    @total_tds_charges.abs + EmployeeOtherIncome.total_billed_tax(@employee,@fy_year.financial_months.last.end_of_month)
  end
  memoize :total_tds

  def total_edu_cess
    (total_tds * (EDUCATION_CESS/ (1 + EDUCATION_CESS))).round
  end
  memoize :total_edu_cess

  def total_tax_on_income
    total_tds - total_edu_cess
  end

  def any_other_income
    EmployeeOtherIncome.total_billed_other_incomes(@employee,@fy_year.financial_months.last.end_of_month)
  end
  
  def total_employee_income
    gross_total_income + any_other_income
  end
  memoize :total_employee_income
  
  def total_taxable_income
    total_employee_income - employee_investments_80c[:deductible_amount]
  end
  
  def tds_returns
    TdsReturn.for_company(@company).in_fy(@fy_year).all(:order => "start_date ASC").group_by{|tds|tds.start_date.financial_quarter}
  end
  memoize :tds_returns
  
  def download_form16
    pdf = Prawn::Document.new(:page_size => "A4",:right_margin => 10,:left_margin => 10)
    pdf.styles :code => {:white_space => :pre}
    pdf.font "Courier"
    pdf.font_size =12
    pdf.bounding_box [0,770],:width => 580 do
      pdf.text "FORM 16", :align=>:center,:style => :bold
      pdf.text "[ See rule 31 (1) (a) ]",:align=>:center,:style => :bold
      pdf.text "Certificate under section 203 of the Income-tax Act 1961 for tax deducted", :align=>:center
      pdf.text "at source from Income chargeable under the head 'Salaries'", :align=>:center
    end
    pdf.bounding_box [0,700],:width=>580 do
      data = Array.new
      data << [@company.name,employee_name]
      data << [@company.complete_address,designation]
      pdf.table data,
        :headers => ["Name and Address of the Employer"," Name and Designation of the Employee"],
        :column_widths => {0 => 290,1=>290},
        :border_width => 1,
        :font_size =>10,
        :align_headers => :center,
        :align => :center,
        :border_color =>"a09d9d"
      data1 =  Array.new
      data1 << [@company.pan,@company.tan,employee_pan]
      pdf.table data1,
        :headers => ["PAN No. of the Deductor","TAN No. of the Deductor","PAN No. of the Employee"],
        :column_widths => {0 => 145,1=>145,2=>290},
        :border_width => 1,
        :font_size =>10,
        :align_headers => :center,
        :align => :center,
        :border_color =>"a09d9d"
      data2 =[['Acknowledgement Nos. of all quartely statements of TDS under sub-section(3) of section 200 as provided by TIN Facilitation Centre or NSDL web-site',
          "PERIOD","Assessment Year"]]
      pdf.table data2,
        :column_widths => {0=>290,1 => 145,2=>145},
        :border_width => 1,
        :font_size =>10,
        :align => :center,
        :border_color =>"a09d9d"
      
      unless tds_returns.blank?
        data3 = tds_returns.map do |q,tr|
          r = tr.first
          [q,r.receipt_number,r.start_date.to_s(:short_month_and_year),r.start_date.end_of_quarter.to_s(:short_month_and_year),""]
        end
        pdf.table data3,
          :headers => ["Quarter","Acknowledgement No.","From","To",@fy_year.formatted_fy],
          :column_widths => {0 => 145,1 =>145,2 => 72, 3=>73,4=>145},
          :border_width => 1,
          :border_style => :grid,
          :font_size =>10,
          :align_headers => :center,
          :align => :center,
          :border_color =>"a09d9d"
      end
      pdf.move_down(5)
      pdf.text "DETAILS OF SALARY PAID AND ANY OTHER INCOME AND TAX DEDUCTED",:style => :bold,:align => :center
      data4= Array.new
      data4 << ['1' ,'Gross Salary','','','']
      data4 << ['','(a) Salary as per provision contained in sec. 17(1)',total_gross,'','']
      data4.concat(self.gross_salary.map{|key,value|
          ['',
            Prawn::Table::Cell.new( :text => "<code class='code'>#{sprintf("%30s: %25.2f",html_escape(key),value)}</code>"),
            '','','']
        })
      data4 << ['','(b) Value of perquisites u/s 17(2) (as per Form No. 12BA, wherever applicable)',0,'','']
      data4 << ['','(c) Profits in lieu of salary under section 17(3) (as per Form No. 12BA, wherever applicable)',0,'','']
      data4 << ['','(d) Total','',total_gross,'']
      data4 << ['2','Less:Allowance to the extent exempt under section 10 ','',total_exempt_amount,'']
      data4.concat(self.exempt_amount.map{|key,value|
          ['',
            Prawn::Table::Cell.new( :text => "<code class='code'>#{sprintf("%30s: %25.2f",html_escape(key),value)}</code>"),
            '','','']
        })
      data4 << ['3','Balance(1-2) ','',gross_total_income,'']
      data4 << ['4','Deductions: ','0','','']
      data4 << ['5','Total Deductions','','0','']
      data4 << ["6","Income chargeable under the head 'Salaries'(3-5)",'','',gross_total_income]
      data4 << ["7","Add: Any other income reported by the employee",'','',any_other_income]
      data4 << ['8',"Gross total income(6+7)",'','',total_employee_income]
      data4 << ["9","Deduction under Chapter VI-A",'','','']
      data4 << ['(A)',
        Prawn::Table::Cell.new( :text => "<code class='code'>#{sprintf("%0s: %26s",'Section 80C,80CCC and 80 CCD','Gross amount')}</code>"),
        'Qualifying Amount','Deductiible amount','']
      data4 << ['','(a) Section 80C',employee_investments_80c[:gross_amount],employee_investments_80c[:deductible_amount],'']
      data4.concat(self.employee_investments_80c[:schemes].map{|key,value|
          ['',
            Prawn::Table::Cell.new( :text => "<code class='code'>#{sprintf("%30s: %25.2f",html_escape(key),value)}</code>"),
            '','','']
        })
      data4 << ['','(b) Section 80CCC',0,0,'']
      data4 << ['','(c) Section 80CCD',0,0,'']
      data4 << ['(B)','Other section(for e.g.80E,80G,etc.) under','','','']
      data4 << ['','(a) Section           (Rs)','','','']
      data4 << ['','(b) Section            (Rs)','','','']
      data4 << ['10','Aggregate of deductible amount under Chapter VIA','','',employee_investments_80c[:deductible_amount]]
      data4 << ['11','Total income(8-10)','','',total_taxable_income]
      data4 << ['12','Tax on total income','','',total_tax_on_income]
      data4 << ['13','Surcharge(on tax computed at S.No.12)','','',0.0]
      data4 << ['14','Eduction Cess @ 3%(on tax at S.No.12 plus surcharge at S.No.13)','','',total_edu_cess]
      data4 << ['15','Tax payable(12+13+14)','','',total_tds]
      data4 << ['16','relief under section 89(attach details)','','',0.0]
      data4 << ['17','Tax payable(15+16)','','',total_tds]
      data4 << ['18','Less:(a)Tax deducted at source u/s 192(1)','','','']
      data4 << ['18','     (b)Tax paid by the employer on behalf of the employee u/s 192{A) on perquisites u/s 17(2)','','','']
      data4 << ['19','Tax payable/refundable(17-18)','','',total_tds]
      pdf.table data4,
        :column_widths => {0 =>30 ,1 => 320,2 =>75,3 => 80, 4=>75},
        :font_size =>10,
        :border_color =>"a09d9d"
    end
    pdf.move_down(5)
    pdf.text "DETAILS OF SALARY PAID AND ANY OTHER INCOME AND TAX DEDUCTED",:style => :bold,:align => :center
    data6= Array.new
    data6 << [1,total_tax_on_income,0.0,total_edu_cess,total_tds,'','','','']
    pdf.table data6,
      :headers => ['#','TDS Rs.','Surcharge Rs.','Education Case Rs.','total tax deposited','Cheque/DD No.(if any)',
      'BSR Code of Bank Branch','Date on which tax deposited ','Transfer voucher / challan id no.'],
      :font_size =>10,
      :border_stlye => :grid,
      :border_color =>"a09d9d",
      :column_widths => {0 =>30 ,1 => 62,2 => 65,3 => 65,4 => 63,5 => 65,6 =>75,7 => 75, 8=>80}
    pdf
  end

  private
  
  def salary_charges
    @employee.salary_slip_charges.in_fy(@fy_year).all(:conditions => "amount > 0") +
      EmployeeInvestment80c.salary_investments(@employee, @fy_year.financial_months.last.end_of_month)
  end

  def slip_charge_under_head(head)
    @employee.salary_slip_charges.under_head(head)
  end
  
  def current_package
    @employee.current_package
  end
  
  
end
