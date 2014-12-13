class LabourWelfareCalculator < Calculator

  attr_accessible :name,:calculator_type
  
  def eligible_for_employee?
    true
  end

  def zone
    @zone ||= company.address.try(:state)
  end

  def welfare_charges
    charge = {:employee_contri => 0, :employer_contri => 0}
    lwf = LabourWelfare.find_by_zone(zone) 
    charge = lwf.calculate_charge(salary_slip) if lwf
    charge
  end

  def calculate
    charge = welfare_charges
    unless charge.values.select{|e| e != 0}.blank?
      [SalaryHead.charges_for_employee_lwf.build(:employee => employee,
                                                 :reference => employee,
                                                 :description => "Labour Welfare Fund, #{zone}",
                                                 :base_charge => charge[:employee_contri],
                                                 :amount => (-1 * charge[:employee_contri])),
       SalaryHead.charges_for_employer_lwf.build(:reference => employee,
                                                 :description => "Labour Welfare Fund, #{zone}",
                                                 :base_charge => charge[:employer_contri],
                                                 :amount => charge[:employer_contri])]
    end
  end

  def is_ready?
    unless company.address.try(:state)
      raise CalculatorError, "Please Select State eligible state for your company to calculate labour welfare."
    end
  end


end
