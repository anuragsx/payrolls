class FlexibleAllowanceCalculator < Calculator

  def employee_added!(employee)
    true
  end

  def amount_for(code)
    0
  end

  def self.promote_package!(package,employee)    
    allowances = package[:flexi_allowance].reject{|k,a| a['value'].blank? or a['value'].to_i == 0} if package[:flexi_allowance]
    if package['id'].blank?
      emp_pack = employee.employee_packages.build(package[:employee_package])
      emp_pack.company = employee.company
      emp_pack.save!     
      unless allowances.blank?
        allowances.each do |k,attrs|
          flexi = FlexibleAllowance.new(attrs)
          flexi.company = employee.company
          flexi.save!
        end
      end
    else      
      @employee_package = EmployeePackage.find(package['id'])
      @employee_package.update_attributes!(package[:employee_package])
      unless allowances.blank?
        allowances.each do |k,v|
          @flexi = FlexibleAllowance.find(k)
          @flexi.update_attributes!(v)
        end
      end
    end
  end
  
  def calculate
    leave_ratio = salary_slip.leave_ratio
    employee_package = employee.effective_package(run_date)
    basic = employee.effective_basic(run_date)
    allowances = [SalaryHead.charges_for_basic.build(:amount => (basic * leave_ratio),
        :base_charge => basic,
        :description => "Basic",
        :reference => employee_package,
        :employee => employee)]
    allowances += CompanyFlexiPackage.all_charges_for_company(company,employee).map do |cfp|
      SalarySlipCharge.new(:amount => cfp.field_charge(basic,leave_ratio),
        :employee => employee,
        :salary_head => cfp.salary_head,
        :reference => cfp,
        :description => cfp.salary_head.name,
        :base_charge => cfp.field_charge(basic,1))
    end
  end

  def calculate_income(company, employee, emp_package, run_date)
    income = {}
    CompanyFlexiPackage.all_charges_for_company(company,employee).map do |cfp|
      amount = cfp.fixed_value(emp_package.basic)
      taxable_amount = cfp.salary_head.calculate_taxable_amount(emp_package.basic, amount, employee, run_date)
      income[cfp.salary_head] = {:amount => amount, :exempt_amount => amount - taxable_amount}
    end
    income
  end

  def calculate_package_ctc(company, employee, emp_package)
    package_ctc = Hash.new()
    CompanyFlexiPackage.all_charges_for_company(company,employee).map do |cfp|
      package_ctc[cfp.salary_head] = cfp.fixed_value(emp_package.basic)
    end
    package_ctc
  end

  def company_classes
    [CompanyFlexiPackage,FlexibleAllowance]
  end

  def employee_classes
    # TODO have some logic to find with category
  end
end
