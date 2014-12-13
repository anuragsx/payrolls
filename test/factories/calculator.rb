class ActiveSupport::TestCase

  Factory.define :dearness_relief_calculator, :class => "DearnessReliefCalculator" do |r|
    r.name "Dearness Relief on Basic + DA"
    r.calculator_type 'Allowance'
  end

  Factory.define :basic_calculator, :class => "BasicCalculator" do |r|
    r.name "Leave Adjusted Basic (default)"
    r.calculator_type 'Package'
  end

  Factory.define :simple_allowance_calculator, :class => "SimpleAllowanceCalculator" do |r|
    r.name "Simple Employee Package designer (default)"
    r.calculator_type 'Package'
  end

  Factory.define :flexi_allowance_calculator, :class => "FlexibleAllowanceCalculator" do |r|
    r.name "Flexible Allowance Manager"
    r.calculator_type 'Package'
  end

  Factory.define :bonus_calculator, :class => "BonusCalculator" do |r|
    r.name "Bonus"
    r.calculator_type 'Subtotal'
  end


  Factory.define :loan_calculator, :class => "LoanCalculator" do |r|
    r.name "Emploee Loan Manager"
    r.calculator_type 'Deduction'
  end

  Factory.define :advance_calculator, :class => "AdvanceCalculator" do |r|
    r.name "Employee Advances"
    r.calculator_type 'Deduction'
  end

  Factory.define :esi_calculator, :class => "EsiCalculator" do |r|
    r.name "ESI"
    r.calculator_type 'Deduction'
  end

  Factory.define :income_tax_calculator, :class => "IncomeTaxCalculator" do |r|
    r.name "Income Tax"
    r.calculator_type 'Deduction'
  end

  Factory.define :simple_income_tax_calculator, :class => "SimpleIncomeTaxCalculator" do |r|
    r.name "Simple Income Tax"
    r.calculator_type 'Deduction'
  end

  Factory.define :pf_calculator, :class => "PfCalculator" do |r|
    r.name "Provident Fund"
    r.calculator_type 'Deduction'
  end

  Factory.define :insurance_calculator, :class => "InsuranceCalculator" do |r|
    r.name "LIC"
    r.calculator_type 'Deduction'
  end

  Factory.define :simple_leave_calculator, :class => "SimpleLeaveCalculator" do |r|
    r.name "Simple Leave Manager"
    r.calculator_type 'Leave'
  end

  Factory.define :leave_accounting_calculator, :class => "LeaveAccountingCalculator" do |r|
    r.name "Leave Account Manager"
    r.calculator_type 'Leave'
  end

  Factory.define :expense_claim_calculator, :class => "ExpenseClaimCalculator" do |r|
    r.name "ExpenseClaimCalculator"
    r.calculator_type 'Deduction'
  end

  Factory.define :calculator, :class => "Calculator" do |c|
    c.name "Calculator"
    c.calculator_type 'Allowance'
  end
  
  def create_calculators
    Factory(:dearness_relief_calculator)
    Factory(:basic_calculator)
    Factory(:simple_allowance_calculator)
    Factory(:flexi_allowance_calculator)
    Factory(:loan_calculator)
    Factory(:advance_calculator)
    Factory(:esi_calculator)
    Factory(:income_tax_calculator)
    Factory(:pf_calculator)
    Factory(:insurance_calculator)
    Factory(:simple_leave_calculator)
    Factory(:leave_accounting_calculator)
    Factory(:expense_claim_calculator)
  end

end