# To change this template, choose Tools | Templates
# and open the template in the editor.
class AdvanceCalculator < Calculator

  extend ActiveSupport::Memoizable
  
  def advances(employee,run_date)
    EmployeeAdvance.for_date(run_date).for_employee(employee).unbilled
  end
  memoize :advances

  def eligible_for_employee?
    # Search for existence of any advances?
    advance = advances(employee,run_date)
    !!advance && (advance.to_a.sum{|s|s.amount.abs} || 0) > 0
  end

  def calculate
    advances(employee,run_date).map do |adv|
      SalaryHead.charges_for_advance.build(:amount => -1.0*adv.amount.abs,
                                           :base_charge => adv.amount,
                                           :description => adv.description,
                                           :reference => adv,
                                           :employee => employee)
    end
  end

  def finalize!
    EmployeeAdvance.finalize_for_slip!(run_date,salary_slip,employee)
  end

  def unfinalize!
    EmployeeAdvance.unfinalize_for_slip!(salary_slip)
  end

  def employee_classes
    EmployeeAdvance
  end
end
