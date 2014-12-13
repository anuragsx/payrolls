class LtaCalculator < Calculator
  extend ActiveSupport::Memoizable
  
  def ltas(employee,run_date)
    Lta.for_employee(employee).for_date(run_date).unbilled
  end
  memoize :ltas


  def eligible_for_employee?
    # Search for existence of any ltas?
    lta = ltas(employee,run_date)
    !lta.blank? && (lta.to_a.sum{|s|s.amount.abs} || 0) > 0
  end

  def calculate
    ltas(employee,run_date).map do |lta|
      SalaryHead.charges_for_lta.build(:amount => lta.amount.abs,
        :base_charge => lta.amount,
        :description => lta.description,
        :reference => lta,
        :employee => employee)
    end
  end

  def finalize!
    Lta.finalize_for_slip!(run_date,salary_slip,employee)
    LtaClaim.finalize_for_slip!(run_date,salary_slip,employee)
  end

  def unfinalize!
    Lta.unfinalize_for_slip!(salary_slip)
    LtaClaim.unfinalize_for_slip!(salary_slip)
  end

  
  def employee_classes
    [Lta,LtaClaim]
  end

end