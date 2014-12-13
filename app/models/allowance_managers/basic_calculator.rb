class BasicCalculator < Calculator

  def promote!(employee_package)
    true
  end

  def self.promote_package!(package,employee)
    package[:start_date] ||= Date.today
    if package['id']
      @employee_package = EmployeePackage.find(package['id'])
      @employee_package.update_attributes!(package[:employee_package])
    else
      e = employee.employee_packages.build(package[:employee_package])
      e.company = employee.company
      e.save!
    end    
  end
  
  def amount_for(code)
    code == "BASIC" ? employee_package.basic : 0
  end

  def calculate
    leave_ratio = salary_slip.leave_ratio
    employee_package = employee.effective_package(run_date)
    basic = employee_package.basic
    [SalaryHead.charges_for_basic.build(:amount => (basic * leave_ratio),
                                        :base_charge => basic,
                                        :description => "Basic",
                                        :reference => employee_package,
                                        :employee => employee)]
  end

  def calculate_package_ctc(company, employee, emp_package)
    return {}
  end
end