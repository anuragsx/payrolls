# To change this template, choose Tools | Templates
# and open the template in the editor.

class BonusCalculator < Calculator

  extend ActiveSupport::Memoizable

  BONUS_THRESHOLD = 10000.00
  BONUS_BASIC = 3500.00

  def effective_basic(employee,run_date)
    employee.effective_package(run_date).try(:basic)
  end
  memoize :effective_basic

  def eligible_for_employee?
    effective_basic(employee,run_date) <= BONUS_THRESHOLD
  end

  def calculate
    if eligible_for_employee?
      basic = [effective_basic(employee,run_date),BONUS_BASIC].min
      amount = basic * salary_slip.leave_ratio
      return [SalaryHead.charges_for_bonus.build(:amount => amount,
                                                 :description => "Bonus aggregated on #{basic}",
                                                 :reference => employee,
                                                 :base_charge => basic)]
    end
  end

  def self.find_bonus_for_employee(emp)
    SalaryHead.charges_for_bonus.for_reference(emp)
  end

  def self.find_bonus_for_company(company,year = nil)
    scope = SalaryHead.charges_for_bonus.for_company(company)
    scope = scope.in_fy(year) unless year.blank?
    scope.all
  end

  def calculate_package_ctc(company, employee, emp_package)
    ctc = {}
    self.run_date = emp_package.start_date
    self.employee = employee
    self.company = company
    if eligible_for_employee?
      ctc[SalaryHead.code_for_bonus] = [effective_basic(employee,self.run_date),BONUS_BASIC].min || 0
    end
    ctc
  end

end
