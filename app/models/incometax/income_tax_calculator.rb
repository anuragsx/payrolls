class IncomeTaxCalculator < Calculator

  def employee_tds(run_date,employee)
    EmployeeTax.for_employee(employee).after_date(run_date).last
  end
  
  def employee_tds_detail
    EmployeeTaxDetail.for_employee(employee).last
  end

  def taxable_earnings(run_date,employee)
    employee.salary_slips.select{|x|x.run_date.financial_year == run_date.financial_year}.sum(0) do |x|
      (x.taxable_gross || 0)
    end
  end

  def eligible_for_employee?
    # First check on the employee if on the employee it exist
    if !!employee_tds(run_date, employee)
      return @tds = employee_tds(run_date, employee)
    elsif !!employee_tds_detail
      # Total Earnings before this month
      @previous_income = taxable_earnings(run_date,employee)
      # Total Earnings this month
      @current_investemnts = salary_slip.charge_for(SalaryHead.code_for_employee_pf).abs +
        salary_slip.charge_for(SalaryHead.code_for_insurance).abs
      @month_income = salary_slip.taxable_allowances - @current_investemnts
      # Total deductions for this year
      @investments = (EmployeeInvestment80c.eligible_amount_invested(EmployeeInvestment80c.total_investments(employee,run_date)))
      @lta_claim = LtaClaim.total_unbilled(employee,run_date)
      @fixed_month_incomes = EmployeeOtherIncome.total_unbilled_other_incomes(employee,run_date)
      @net_annual_taxable_income = @previous_income + @month_income - @investments + @fixed_month_incomes - @lta_claim
      @annual_tax_liability = employee_tds_detail.tax_amount(@net_annual_taxable_income,run_date)
      total_tax_paid_already = SalaryHead.charges_for_tds.for_employee(employee).in_fy(run_date.financial_year).sum(:amount) +
                               EmployeeOtherIncome.total_unbilled_tax(employee,run_date)
      @tds_amount_for_month = @annual_tax_liability - total_tax_paid_already.abs
      @tds = employee_tds_detail
      return true
    end
    false
  end

  def calculate
    if eligible_for_employee?
      effective_tax = @tds
      if effective_tax.kind_of?(EmployeeTax)
        base_charge = effective_amount = effective_tax.amount
        @net_annual_taxable_income = @previous_income = @month_income = @investments = @fixed_month_incomes = 0
      elsif effective_tax.kind_of?(EmployeeTaxDetail)
        effective_amount = @tds_amount_for_month
        base_charge = @annual_tax_liability
      end
      if effective_amount > 0
        [SalaryHead.charges_for_tds.build(:employee => employee,
            :amount => -1.0 * effective_amount.round,
            :base_charge => base_charge.round,
            :reference => effective_tax,
            :description => "#{effective_tax.description} based on net earnings of #{@net_annual_taxable_income} prev : #{@previous_income} this : #{@month_income} investments #{@investments} current invest #{@current_investemnts}")]
      end
    end
  end

  def finalize!
    EmployeeOtherIncome.finalize_for_slip!(run_date,salary_slip,employee)
  end

  def unfinalize!
    EmployeeOtherIncome.unfinalize_for_slip!(salary_slip)
  end

  def employee_classes
    [EmployeeTax,EmployeeTaxDetail,EmployeeInvestment80c, EmployeeOtherIncome]
  end

  def get_income_tax_pdf_content(pdf, presenter, salary_slip, cell_height)
    space_char = '.'
    pdf.bounding_box [-10,(640-cell_height)],:width =>560 do
      pdf.text "<b>Income Tax Worksheet From #{salary_slip.tds.from_date} To #{salary_slip.tds.to_date} (On Annualised Earnings)</b>",:align => :center
    end
    pdf.cell [-10, (630-cell_height)], :width=>220, :height=> 400,:border_color =>"a09d9d",:borders => [:left,:top,:bottom]
    pdf.cell [169, (630-cell_height)], :width=>101, :height=> 400,:border_color =>"a09d9d",:borders => [:right,:top,:bottom]
    data = [[{:text => "<u>Emoluments Paid</u>", :colspan => 2}]]
    data.concat(
      salary_slip.tds.emoluments[:emoluments_paid].map{|k,v| [k.ljust(34, space_char),v]}
    )
    data << [{:text => "Gross Earnings".ljust(34, space_char),:font_style=> :bold},"<b><u>#{salary_slip.tds.emoluments[:total_emoluments_paid]}</u></b>"]
    data << [{:text => "<u>Less: Exemptions</u>", :colspan => 2}]
    data.concat(
      salary_slip.tds.emoluments[:exempt_allowance].map{|k,v| [k.ljust(34, space_char),v]}
    )
    data << ["Deductions Under Chap VIA".ljust(34, space_char),salary_slip.tds.eligible_investment_amount]
    data << [{:text =>'Total'.ljust(34, space_char),:font_style=>:bold},
          "<b><u>#{salary_slip.tds.emoluments[:total_exempt_allowance] + salary_slip.tds.eligible_investment_amount}</u></b>"]
    (data <<   [{:text => "#{salary_slip.tds.emoluments[:lta_claim][:name]}".ljust(34, space_char),:font_style=>:bold},"<b><u>#{salary_slip.tds.emoluments[:lta_claim][:amount]}</u></b>"])unless salary_slip.tds.emoluments[:lta_claim][:amount].zero?

    data.concat([
        [{:text => "#{salary_slip.tds.emoluments[:taxable_other_income][:name]}".ljust(34, space_char),:font_style=>:bold},"<b><u>#{salary_slip.tds.emoluments[:taxable_other_income][:amount]}</u></b>"],
        [{:text => "Net Taxable Income(Rounded)".ljust(34, space_char),:font_style=>:bold},"<b><u>#{salary_slip.tds.emoluments[:taxable_income]}</u></b>"],
        ["Net Tax".ljust(34, space_char),salary_slip.tds.current_month],
        ["Net Edu Cess".ljust(34, space_char),salary_slip.tds.edu_cess],
        [{:text =>"Total Tax Payable".ljust(34, space_char),:font_style=>:bold},"<b><u>#{salary_slip.tds.upto_current_month}</u></b>"],
        [{:text =>"Total Tax Paid".ljust(34, space_char),:font_style=>:bold},"<b><u>#{salary_slip.tds.last_month}</u></b>"],
        [{:text => "Total Tax Deduct for #{presenter.month_date}".ljust(34, space_char),:font_style=>:bold},
          "<b><u>#{salary_slip.tds.current_month}</u></b>"]
      ])
    pdf.bounding_box [-10,(630-cell_height)], :width=>280 do
      pdf.table data,
        :column_widths => {0 => 214,1 => 66},
        :border_width =>0,
        :align => {0 =>:left ,1 => :right},
        :width => 280,
        :vertical_padding => 2.5,
        :font_size => 10,
        :horizontal_padding => 5
    end
    pdf.cell [270, (630-cell_height)], :width=>180, :height=> 400,:border_color =>"a09d9d",:borders => [:top,:bottom]
    pdf.cell [449, (630-cell_height)], :width=>101, :height=> 400,:border_color =>"a09d9d",:borders => [:right,:top,:bottom]
    pdf.bounding_box [270,(630-cell_height)], :width=>280 do
      examp_data =[[{:text => '<u>Deductions Under Chap VIA</u>', :colspan => 2}],
        [{:text => '<u>80C/ 80CCC/ 80CCD - Investments</u>', :colspan => 2}]]
      examp_data.concat(salary_slip.tds.employee_investments_80c[:investments].map{|k,v| [k.ljust(30, space_char),v]})
      examp_data.concat([
          [{:text =>"Total Amount Invested".ljust(30, space_char),:font_style=>:bold},"<b><u>#{salary_slip.tds.employee_investments_80c[:investment_amount]}</u></b>"],
          ["Total Eligible Amount".ljust(30, space_char),salary_slip.tds.eligible_investment_amount],
          [{:text => '<u>HRA Exemption Calculation</u>',:colspan => 2}],
          ['Total Basic'.ljust(30, space_char),salary_slip.tds.emoluments[:emoluments_paid]["Basic"]],
          ['1. Actual HRA'.ljust(30, space_char),salary_slip.tds.emoluments[:emoluments_paid]["Rent"]],
          ["2. Rent > 10% Basic".ljust(30, space_char),salary_slip.tds.emoluments[:basic10]],
          ["3. 50%(M) / 40%(NM) Basic".ljust(30, space_char),salary_slip.tds.emoluments[:basic50]],
          [{:text =>"Least of 1,2,3 is Exempt".ljust(30, space_char),:font_style=>:bold},"<b><u>#{salary_slip.tds.emoluments[:min]}</u></b>"]
        ])
      pdf.table examp_data,
        :column_widths => {0 => 190,1 => 90},
        :border_width =>0,
        :width => 280,
        :vertical_padding => 2.5,
        :font_size => 10,
        :align => {0 =>:left ,1 => :right},
        :horizontal_padding => 5
    end
  end
end