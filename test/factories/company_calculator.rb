class ActiveSupport::TestCase
  
  Factory.define :company_calculator do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:calculator)}
  end
  
  Factory.define :simple_leave_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:simple_leave_calculator)}
    r.position 1
  end

  Factory.define :leave_accounting_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:leave_accounting_calculator)}
    r.position 1
  end

  Factory.define :dearness_relief_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:dearness_relief_calculator)}
    r.position 3
  end

  Factory.define :basic_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:basic_calculator)}
    r.position 2
  end

  Factory.define :simple_allowance_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:simple_allowance_calculator)}
    r.position 2
  end

  Factory.define :flexi_allowance_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:flexi_allowance_calculator)}
    r.position 2
  end

  Factory.define :default_slip_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:default_slip_calculator)}
    r.position 4
  end

  Factory.define :employee_loan_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:loan_calculator)}
    r.position 3
  end

  Factory.define :employee_advance_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:advance_calculator)}
    r.position 3
  end

  Factory.define :esi_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:esi_calculator)}
    r.position 3
  end

  Factory.define :expense_claim_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:expense_claim_calculator)}
    r.position 3
  end
  
  Factory.define :income_tax_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:income_tax_calculator)}
    r.position 3
  end

  Factory.define :simple_income_tax_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:simple_income_tax_calculator)}
    r.position 4
  end

  Factory.define :pf_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:pf_calculator)}
    r.position 3
  end

  Factory.define :insurance_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:insurance_calculator)}
    r.position 3
  end

  Factory.define :bonus_company_calculator, :class => "CompanyCalculator" do |r|
    r.company {|c| c.association(:company)}
    r.calculator {|c| c.association(:bonus_calculator)}
    r.position 4
  end
end