class ArrearCalculator < Calculator

  attr_accessible :type, :name, :calculator_type

  def calculate
    Arrear.for_employee(employee).arrear_in(run_date).unbilled.all.map do |arrear|
      SalaryHead.charges_for_arrear.build(:employee => employee,
                                                 :amount => arrear.amount.abs,
                                                 :base_charge => arrear.amount.abs,
                                                 :reference => arrear,
                                                 :description => arrear.description)
    end
  end
  
  def finalize!
    Arrear.finalize_for_slip!(run_date,salary_slip,employee)
  end

  def unfinalize!
    Arrear.unfinalize_for_slip!(salary_slip)
  end

  def employee_classes
    Arrear
  end
end
