class IncomeTaxPresenter
  extend ActiveSupport::Memoizable
  include ActionView::Helpers::NumberHelper

  def initialize(slip)
    @@employee_tds_head ||= SalaryHead.code_for_tds
    @@emplyee_hra_head ||= SalaryHead.code_for_rent
    @slip = slip
    @employee = slip.employee
  end

  def eligible_investment_amount
    EmployeeInvestment80c.eligible_amount_invested(employee_investments_80c[:investment_amount])
  end
  memoize :eligible_investment_amount

  def from_date
    @slip.run_date.to_date.beginning_of_financial_year.to_s(:date_month_and_year)
  end
  
  def to_date
    @slip.run_date.end_of_financial_year.to_s(:date_month_and_year)
  end    

  def run_date
    @slip.run_date
  end

  def employee_investments_80c
    tds_info = {:investment_amount => 0.0,
      :investments => {}
    }
    EmployeeInvestment80c.effective_investments(@employee,@slip.run_date).map do |e|
      tds_info[:investments][e.employee_investment_scheme.name]= e.amount
      tds_info[:investment_amount]+=e.amount
    end
    EmployeeInvestment80c.salary_investments(@employee,@slip.run_date).map do |c|
      tds_info[:investments][c.salary_head.short_name]= c.amount.abs
      tds_info[:investment_amount]+=c.amount.abs
    end
    tds_info
  end
  memoize :employee_investments_80c

  def current_month
    @slip.billed_charge_for(@@employee_tds_head).abs
  end
  memoize :current_month
  
  def upto_current_month
    @slip.base_charge_for_head(@@employee_tds_head).abs
  end
  memoize :upto_current_month
  
  def last_month
    upto_current_month - current_month
  end
  memoize :last_month
  
  def edu_cess(amount = upto_current_month)
    number_with_precision((amount * (EDUCATION_CESS/ (1 + EDUCATION_CESS))).round, :precision => 1)
  end
  memoize :edu_cess
  
  def emoluments
    e_info ={:exempt_allowance => {},
      :emoluments_paid => {},
      :total_emoluments_paid => 0.0,
      :total_exempt_allowance => 0.0,
      :gross_total_income => 0.0,
      :taxable_income => 0.0,
      :taxable_other_income => 0.0,
      :lta_claim => {}
    }
    emoluments_name.map(&:salary_head).each do |h|
      e_info[:exempt_allowance][h.name] = 0.0
      e_info[:emoluments_paid][h.name] = 0.0
      (SalarySlipCharge.under_head(h).for_employee(@employee).upto_date_within_fy(@slip.financial_year,@slip.run_date)).each do |c|
        e_info[:emoluments_paid][h.name] += c.amount.abs
        e_info[:exempt_allowance][h.name] += c.exempt_amount.abs
      end
      e_info[:total_emoluments_paid] +=  e_info[:emoluments_paid][h.name]
      e_info[:total_exempt_allowance] += e_info[:exempt_allowance][h.name]
    end
     
    e_info[:exempt_allowance].delete_if {|key, value| value == 0.0 }
    e_info[:gross_total_income] = e_info[:total_emoluments_paid] - e_info[:total_exempt_allowance]
    e_info[:taxable_other_income] = employee_other_income
    e_info[:lta_claim] = employee_lta_claim
    e_info[:taxable_income]= e_info[:gross_total_income]  + e_info[:taxable_other_income][:amount] - eligible_investment_amount - e_info[:lta_claim][:amount]
    hr_hash = init_hra_formula(e_info[:emoluments_paid]["Rent"],
      e_info[:emoluments_paid]["Basic"],
      e_info[:exempt_allowance]["Rent"])
    e_info.merge!(hr_hash)
  end
  memoize :emoluments
  
  def annual_emoluments
    e_info ={:exempt_allowance => {},
      :emoluments_paid => {},
      :total_emoluments => 0.0,
      :total_exempt_allowance => 0.0,
      :gross_total_income => 0.0,
      :taxable_income => 0.0,
      :taxable_other_income => 0.0,
      :lta_claim => {}
    }
    e_info[:total_emoluments] = {:paid_amount => 0.0, :future_amount => 0.0, :total_amount => 0.0}
    e_info[:total_exempt_allowance] = {:paid_amount => 0.0, :future_amount => 0.0, :total_amount => 0.0}
    emoluments_name.map(&:salary_head).each do |h|
      e_info[:exempt_allowance][h.name] = {:paid_amount => 0.0, :future_amount => 0.0, :total_amount => 0.0}
      e_info[:emoluments_paid][h.name] = {:paid_amount => 0.0, :future_amount => 0.0, :total_amount => 0.0}
      (SalarySlipCharge.under_head(h).for_employee(@employee).upto_date_within_fy(@slip.financial_year,@slip.run_date)).each do |c|
        e_info[:emoluments_paid][h.name][:paid_amount] += c.amount.abs
        e_info[:exempt_allowance][h.name][:paid_amount] += c.exempt_amount.abs
      end

      e_info[:emoluments_paid][h.name][:total_amount] += e_info[:emoluments_paid][h.name][:paid_amount]
      e_info[:exempt_allowance][h.name][:total_amount] += e_info[:exempt_allowance][h.name][:paid_amount]

      e_info[:total_emoluments][:paid_amount] +=  e_info[:emoluments_paid][h.name][:paid_amount]
      e_info[:total_exempt_allowance][:paid_amount] += e_info[:exempt_allowance][h.name][:paid_amount]
    end
    if @employee.company.has_calculator?(AnnuallyEquatedTaxCalculator)
      future_heads = []
      left_months.each do |month|
        e_info[:emoluments_paid]["Basic"][:future_amount] += @employee.effective_basic(month) if e_info[:emoluments_paid]["Basic"]
        future_heads << @employee.estimated_for_month(month).first.try(:keys)
        future_heads.flatten!.try(:uniq!)
        if @employee.estimated_for_month(month).first
          @employee.estimated_for_month(month).first.each do |h, value|
            e_info[:emoluments_paid][h.name][:future_amount] += value[:amount] if e_info[:emoluments_paid][h.name]
            e_info[:exempt_allowance][h.name][:future_amount] += value[:exempt_amount] if e_info[:exempt_allowance][h.name]
          end
        end
      end
      if e_info[:emoluments_paid]["Basic"]
        e_info[:emoluments_paid]["Basic"][:total_amount] += e_info[:emoluments_paid]["Basic"][:future_amount]
        e_info[:total_emoluments][:future_amount] += e_info[:emoluments_paid]["Basic"][:future_amount]
        e_info[:total_emoluments][:total_amount] += e_info[:emoluments_paid]["Basic"][:total_amount]
      end
      future_heads.each do |h|
        if e_info[:emoluments_paid][h.name]
          e_info[:emoluments_paid][h.name][:total_amount] += e_info[:emoluments_paid][h.name][:future_amount]
          e_info[:total_emoluments][:future_amount] += e_info[:emoluments_paid][h.name][:future_amount]
          e_info[:total_emoluments][:total_amount] += e_info[:emoluments_paid][h.name][:total_amount]
        end
        if e_info[:exempt_allowance][h.name]
          e_info[:exempt_allowance][h.name][:total_amount] += e_info[:exempt_allowance][h.name][:future_amount]
          e_info[:total_exempt_allowance][:future_amount] += e_info[:exempt_allowance][h.name][:future_amount]
          e_info[:total_exempt_allowance][:total_amount] += e_info[:exempt_allowance][h.name][:total_amount]
        end

      end
    end
    e_info[:exempt_allowance].delete_if {|key, value| value[:total_amount] == 0.0 }
    e_info[:left_months] = left_months
    
    e_info[:gross_total_income] = e_info[:total_emoluments][:total_amount] -
      e_info[:total_exempt_allowance][:total_amount]

    e_info[:taxable_other_income] = employee_other_income
    e_info[:lta_claim] = employee_lta_claim
    
    e_info[:taxable_income]= e_info[:gross_total_income]  + e_info[:taxable_other_income][:amount] - eligible_investment_amount - e_info[:lta_claim][:amount]
    
    e_info[:tax_on_total_income] = employee_tds_detail.try(:tax_amount, e_info[:taxable_income], @slip.run_date) || 0

    e_info[:tax_already_paid] = SalaryHead.charges_for_tds.for_employee(@employee).in_fy(@slip.run_date.financial_year).sum(:amount).abs -
      current_month
    e_info[:other_income_tax] = EmployeeOtherIncome.total_other_tax(@employee,@slip.run_date).abs
    e_info[:left_annual_tax] = e_info[:tax_on_total_income] - (e_info[:tax_already_paid] + e_info[:other_income_tax])
    e_info[:emoluments_paid]["Rent"] = {:paid_amount => 0.0, :future_amount => 0.0, :total_amount => 0.0} unless e_info[:emoluments_paid]["Rent"]
    e_info[:emoluments_paid]["Basic"] = {:paid_amount => 0.0, :future_amount => 0.0, :total_amount => 0.0} unless e_info[:emoluments_paid]["Basic"]
    e_info[:exempt_allowance]["Rent"] = {:paid_amount => 0.0, :future_amount => 0.0, :total_amount => 0.0} unless e_info[:exempt_allowance]["Rent"]
    hr_hash = init_hra_formula(e_info[:emoluments_paid]["Rent"][:total_amount],
      e_info[:emoluments_paid]["Basic"][:total_amount],
      e_info[:exempt_allowance]["Rent"][:total_amount])
    e_info.merge!(hr_hash)
  end
  memoize :annual_emoluments

  def employee_other_income
    {:amount => EmployeeOtherIncome.total_billed_other_incomes(@employee, @slip.run_date),
      :name => "Employee Other Income"}
  end
  memoize :employee_other_income
  
  def employee_lta_claim
    {:amount => LtaClaim.total_billed(@employee, @slip.run_date),
      :name => "LTA"}
  end
  memoize :employee_lta_claim
  
  def financial_months
    @slip.financial_year.financial_months
  end

  def left_months 
    financial_months.delete_if{|y| y if y <= @slip.run_date.beginning_of_month}
  end

  def number_of_months_to_calculate_monthly_rent
    SalaryHead.charges_for_rent.for_employee(@employee).in_fy(@slip.run_date.financial_year).size + left_months.size
  end

  def employee_tds_detail
    EmployeeTaxDetail.for_employee(@employee).last
  end


  
  private
  
  def init_hra_formula(rent,basic,exem_rent)
    object = HraTaxFormula.new
    object.amount = rent
    object.rent_paid = employee_tds_detail.try(:monthly_rent_paid) * number_of_months_to_calculate_monthly_rent if employee_tds_detail.try(:monthly_rent_paid)
    object.employee = @employee
    object.basic = basic
    {:basic10 => object.rent_greater_than_10_percent_of_basic,
      :basic50 => object.metro_based_exemption,
      :min =>  exem_rent
    }
  end

  def emoluments_name
   @slip.allowance_charges + EmployeeInvestment80c.salary_investments(@employee,@slip.run_date)
  end
  
  def slip_charge_under_head(head)
    @slip.salary_slip_charges.under_head(head)
  end


end
