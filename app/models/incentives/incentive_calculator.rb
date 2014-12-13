class IncentiveCalculator < Calculator

  attr_accessible :type, :name, :calculator_type

  def calculate
    Incentive.for_employee(employee).incentive_in(run_date).unbilled.all.map do |incentive|
      SalaryHead.charges_for_incentive.build(:employee => employee,
                                                 :amount => incentive.amount.abs,
                                                 :base_charge => incentive.amount.abs,
                                                 :reference => incentive,
                                                 :description => incentive.description)
    end
  end
  
  def finalize!
    Incentive.finalize_for_slip!(run_date,salary_slip,employee)
  end

  def unfinalize!
    Incentive.unfinalize_for_slip!(salary_slip)
  end

  def employee_classes
    Incentive
  end
end
