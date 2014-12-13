# To change this template, choose Tools | Templates
# and open the template in the editor.

class InsuranceCalculator < Calculator
  extend ActiveSupport::Memoizable

  def employee_policies(run_date,employee)
    EmployeeInsurancePolicy.active_on(run_date).for_employee(employee).all
  end
  memoize :employee_policies

  def eligible_for_employee?
    !!employee_policies(run_date, employee)
  end

  def calculate
    employee_policies(run_date,employee).map do |policy|
      SalaryHead.charges_for_insurance.build(:employee => employee,
                                             :amount => -1.0*policy.monthly_premium.abs,
                                             :base_charge => policy.monthly_premium,
                                             :reference => policy,
                                             :description => policy.description)
    end
  end

  def employee_classes
    EmployeeInsurancePolicy
  end
end
