class GratuityCalculator < Calculator
  GRATUITY_PERCENT = 5

  def total_gratuity_earned(employee)
    SalaryHead.charges_for_gratuity_earned.for_employee(employee).sum(:amount)
  end

  def all_gratuity_earned_by(employee)
    SalaryHead.charges_for_gratuity_earned.for_employee(employee).all
  end

  def eligible_for_employee?
    true
  end

  def calculate
    basic = salary_slip.charge_for(SalaryHead.code_for_basic)
    da = salary_slip.charge_for(SalaryHead.code_for_da)
    dr = salary_slip.charge_for(SalaryHead.code_for_dearness_relief)
    base_charge = (basic + dr).round(2).abs
    amount = (base_charge * GRATUITY_PERCENT / 100.0).round.abs
    [SalaryHead.charges_for_gratuity_earned.build(
        :amount => amount,
        :reference => employee,
        :base_charge => base_charge,
        :description => "Gratuity Contributed at #{GRATUITY_PERCENT}% on #{base_charge}"),
      SalaryHead.charges_for_gratuity_earned.build(
        :amount => amount,
        :employee =>  employee,
        :reference => employee,
        :base_charge => base_charge,
        :description => "Gratuity Added at #{GRATUITY_PERCENT}% on #{base_charge}"),
      SalaryHead.charges_for_gratuity_withheld.build(
        :amount => -1 * amount,
        :employee =>  employee,
        :reference => company,
        :base_charge => base_charge,
        :description => "Gratuity Deducted at #{GRATUITY_PERCENT}% on #{base_charge}")
    ]
  end
end