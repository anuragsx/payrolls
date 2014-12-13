class PfForm6a
  extend ActiveSupport::Memoizable
  
  def initialize(company,year)
    @fy_year = year
    @company = company
    @total_base_charge = 0.0
    @total_emp_pf = 0.0
    @total_employer_epf = 0.0
    @total_employer_pf = 0.0
    @total_vpf = 0.0
    @employee_pf = []
    @dept_detail ={ }
    @company.salary_slips.in_fy(@fy_year).group_by{|x|x.employee}.each do |employee,slips|
      employee_pf =  employee_pf(employee)
      @slip_presenters = slips.map{|c|SalarySlipPf.new(c)}
      @dept_detail[employee.name] = {:account_number => employee_pf.try(:epf_number),
        :base_amount => @slip_presenters.sum(&:total_base_charge),
        :employee_epf  => @slip_presenters.sum(&:total_employee_contribution) ,
        :employer_epf => @slip_presenters.sum(&:total_employer_epf_contribution),
        :employer_pf  => @slip_presenters.sum(&:total_employer_pf_contribution),
        :voluntary_rate => employee_pf.try(:vpf_amount) || employee_pf.try(:vpf_percent) || 0.0
      }
      @total_base_charge += @dept_detail[employee.name][:base_amount]
      @total_emp_pf += @dept_detail[employee.name][:employee_epf]
      @total_employer_epf += @dept_detail[employee.name][:employer_epf]
      @total_employer_pf += @dept_detail[employee.name][:employer_pf]
      @total_vpf += @dept_detail[employee.name][:voluntary_rate]
      @employee_pf << employee_pf
    end
  end
  
  def pf_number
    CompanyPf.pf_number(@company)
  end

  def statutory_rate
    CompanyPf.statutory_rate(@company)
  end
  
  def voluntarily_member
    @employee_pf.map{|pf| pf.try(:vpf_amount) || pf.try(:vpf_percent)}.compact.size
  end
  
  def dept_detail
    @dept_detail
  end
 
  def total_base_charge
    @total_base_charge
  end

  def total_employee_pf
    @total_emp_pf
  end

  def total_employer_epf
    @total_employer_epf
  end
  
  def total_employer_pf
    @total_employer_pf
  end

  def total_vpf
    @total_vpf
  end

  def generate_pdf
    pdf = Prawn::Document.new(:page_layout => :landscape,:page_size => "A4",:margin_right => 10,
      :margin_top => 10,:margin_left => 10, :margin_bottom => 10 )
    pdf.font "Courier"
    pdf.font_size =9
    pdf.bounding_box [0,540], :width => 780 do
      pdf.text "Form 6A (Revised)",:align => :center,:style => :bold
      pdf.text "THE EMPLOYEE'S PROVIDENT FUND SCHEME, 1952 [Paragraph 43]  AND  ",:align => :center,:style => :bold
      pdf.text "THE EMPLOYEE'S PENSION SCHEME, 1995 [Paragraph 20(4)]",:align => :center,:style => :bold
      pdf.text "Annual Statement of contribution for the currency period from 1st March #{@fy_year} to 28th Feb #{@fy_year+1}",:align => :center,:size => 8
    end
    pdf.bounding_box [0,500], :width=>400 do
      pdf.table [["Name",@company.name],
        ["Address ",@company.complete_address],
        ["Code Number",pf_number]],
        :column_widths => {0 => 140,1 => 260},
        :border_width =>0,
        :font_size => 9
    end
    pdf.bounding_box [400,500], :width=>340 do
      pdf.table [["Statutory rate of contribution",statutory_rate],
        ["Number of members voluntarily contribution at a higher rate",voluntarily_member],
        ],
        :column_widths => {0 => 200,1 => 140},
        :border_width =>0,
        :font_size => 9
    end
    s_no = 0    
    data = (dept_detail.map do |key,value|
         [s_no += 1,value[:account_number],key,
          value[:base_amount],
          value[:employee_epf],
          value[:employer_epf],
          value[:employer_pf],'',value[:voluntary_rate],'']
      end) << ['','','Grand Total',total_base_charge,total_employee_pf,
      total_employer_epf,total_employer_pf,'',total_vpf,'']
    pdf.move_down(20)
    pdf.table data,
      :headers => ['#','Account Number','Name',"Wages Retaining Allowance (if any)and D.A. including  cash value of food concession paid during the currency period",
      "Amount of Workers contributions deducted from the wages","Employer's E.P.F.","Employer's Pension Fund","Refund of Advances",
      'Rate of higher Voluntary Contribution (if any)',"Remark"],
      :font_size => 10,
      :border_style => :grid,
      :column_widths => {0 => 20, 1 => 80, 2 => 100, 3 => 100,
      4 => 90, 5 => 80,6 => 80 ,7 => 90,8 => 80},
      :vertical_padding => 2,
      :border_color =>"a09d9d"
    pdf.move_down(10)
    pdf.text "Reconsilation of Remittance"
    pdf.move_down(10)
    pdf.text "(1) Certified that the difference between the figures of total  contribution and admin charges  remitted during the currency  period"
    pdf.text "    and those shown under cols. 5 and 7 above is solely due to the rounding off. of the amounts to nearest 25/50 paise under the rules"
    pdf.text "(2) Certified that the form 3A duly completed of all the members listed in this statement are enclosed except those already sent during the"
    pdf.text "    course of the currency for the final settlement of  the concerned members account Vide Remarks furnished against the name of the "
    pdf.text "    respective members above."
    pdf
  end

  private
  
  def employee_pf(employee)
    EmployeePension.for_company(@company).for_employee(employee).first
  end
 
end
