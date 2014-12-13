# To change this template, choose Tools | Templates
# and open the template in the editor.

class SimpleAllowanceCalculator < Calculator
  
  def promote!(employee_package)
    # Loop thru and create new EmployeePackageHeads for the new employee_
    true
  end

  def self.promote_package!(package,employee)    
    employee_package = package[:employee_package]
    employee_package[:employee_package_heads_attributes].reject{|k,a| a['amount'].blank?} if employee_package[:employee_package_heads_attributes]
    if package['id'].blank?      
      emp_pack = employee.employee_packages.build(employee_package)
      emp_pack.company = employee.company
      emp_pack.employee_package_heads.each{|c| c.company = employee.company}
      emp_pack.save!
    else      
      @employee_package = EmployeePackage.find(package['id'])
      @employee_package.update_attributes!(employee_package)
    end
  end

  def amount_for(code)
    EmployeePackageHead.for_employee(employee).for_head(code).first.try(:amount,0) || 0
  end

  def calculate
    leave_ratio = salary_slip.leave_ratio
    employee_package = employee.effective_package(run_date)
    basic = employee_package.basic
    allowances = [SalaryHead.charges_for_basic.build(:amount => (basic * leave_ratio),
                                                     :base_charge => basic,
                                                     :description => "Basic",
                                                     :reference => employee_package,
                                                     :employee => employee)]
    allowances += EmployeePackageHead.for_company(company).for_package(employee_package).map do |eph|
      amount = eph.leave_dependent ? eph.amount * leave_ratio : eph.amount
      eph.salary_head.salary_slip_charges.build(:amount => amount,
                                                :reference => eph,
                                                :description => eph.salary_head.name,
                                                :base_charge => eph.amount,
                                                :employee => employee)
    end
    return allowances
  end

  def calculate_income(company, employee, emp_package, run_date)
    income = {}
    EmployeePackageHead.for_company(company).for_package(emp_package).map do |eph|
      taxable_amount = eph.salary_head.calculate_taxable_amount(emp_package.basic, eph.amount, employee, run_date)
      income[eph.salary_head] = {:amount => eph.amount, :exempt_amount => eph.amount - taxable_amount}
    end
    income
  end

  def calculate_package_ctc(company, employee, emp_package)
    package_ctc = Hash.new()
    EmployeePackageHead.for_company(company).for_package(emp_package).map do |eph|
      package_ctc[eph.salary_head] = eph.amount
    end
    package_ctc
  end

  def delete_classes
    [CompanyAllowanceHead,EmployeePackageHead]
  end

  def employee_classes
    EmployeePackageHead
  end
end
