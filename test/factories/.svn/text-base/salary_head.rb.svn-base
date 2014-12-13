class ActiveSupport::TestCase

  Factory.define :salary_head, :class => 'SalaryHead' do |s|
    s.name 'Salary Head'
    s.code  'salaryhead'
    s.tax_formula "TaxFormula"
  end

  Factory.define :basic, :class => 'SalaryHead' do |s|
    s.name 'Basic'
    s.code  'basic'
    s.salary_head_type 'Special'
    s.tax_formula "TaxFormula"
  end

  Factory.define :da, :class => 'SalaryHead' do |s|
    s.name 'Dearness'
    s.code  'da'
    s.salary_head_type 'Allowance'
    s.tax_formula "TaxFormula"
  end

  Factory.define :dearness_relief, :class => 'SalaryHead' do |s|
    s.name 'Dearness Relief'
    s.code  'dearness_relief'
    s.tax_formula "TaxFormula"
  end

  Factory.define :med, :class => 'SalaryHead' do |s|
    s.name 'Medical'
    s.code  'medical'
    s.salary_head_type 'Allowance'
    s.tax_formula "MedicalReimbursementTaxFormula"
  end

  Factory.define :hra, :class => 'SalaryHead' do |s|
    s.name 'Rent'
    s.code  'rent'
    s.salary_head_type 'Allowance'
    s.tax_formula "HraTaxFormula"
  end

  Factory.define :tvl, :class => 'SalaryHead' do |s|
    s.name 'Conveyance'
    s.code  'conveyance'
    s.salary_head_type 'Allowance'
    s.tax_formula "TvlTaxFormula"
  end

  Factory.define :laundry, :class => 'SalaryHead' do |s|
    s.name 'Laundry'
    s.code  'laundry'
    s.salary_head_type 'Allowance'
    s.tax_formula "TaxFormula"
  end

  Factory.define :esi_employee_contrib, :class => 'SalaryHead' do |s|
    s.name 'ESI Employee Contribution'
    s.code  'employee_esi'
    s.tax_formula "TaxFormula"
  end

  Factory.define :esi_employer_contrib, :class => 'SalaryHead' do |s|
    s.name 'ESI Employer Contribution'
    s.code  'employer_esi'
    s.tax_formula "TaxFormula"
  end

  Factory.define :pension_admin_contrib, :class => 'SalaryHead' do |s|
    s.name 'PF Admin Charge Contribution'
    s.code  'employer_pf_admin'
    s.tax_formula "TaxFormula"
  end

  Factory.define :pension_edli_contrib, :class => 'SalaryHead' do |s|
    s.name 'PF EDLI Charge Contribution'
    s.code  'employer_pf_edli'
    s.tax_formula "TaxFormula"
  end

  Factory.define :pension_inspection_contrib, :class => 'SalaryHead' do |s|
    s.name 'PF Inspection Contribution'
    s.code  'employer_pf_inspection'
    s.tax_formula "TaxFormula"
  end

  Factory.define :pf_employee_contrib, :class => 'SalaryHead' do |s|
    s.name 'PF Employee Contribution'
    s.code  'employee_pf'
    s.tax_formula "TaxFormula"
  end

  Factory.define :voluntary_pf_contrib, :class => 'SalaryHead' do |s|
    s.name 'Voluntary Employee PF Contribution'
    s.code 'employee_vpf'
    s.tax_formula "TaxFormula"
  end

  Factory.define :epf_employer_contrib, :class => 'SalaryHead' do |s|
    s.name 'EPF Employer Contribution'
    s.code  'employer_epf'
    s.tax_formula "TaxFormula"
  end


  Factory.define :pension_fund_contrib, :class => 'SalaryHead' do |s|
    s.name 'Pension Fund Contribution'
    s.code  'employer_pf'
    s.tax_formula "TaxFormula"
  end

  #Factory.define :pension_contrib, :class => 'SalaryHead' do |s|
  #  s.name 'Pension Contribution'
  #  s.code  'PENSION_CONTRIB_CODE'
  #  s.tax_formula "TaxFormula"
  #end

  Factory.define :tds, :class => 'SalaryHead' do |s|
    s.name 'Income Tax'
    s.code  'tds'
    s.tax_formula "TaxFormula"
  end

  Factory.define :bonus, :class => 'SalaryHead' do |s|
    s.name 'Bonus'
    s.code  'bonus'
    s.tax_formula "TaxFormula"
  end

  Factory.define :adv, :class => 'SalaryHead' do |s|
    s.name 'Advance'
    s.code  'advance'
    s.tax_formula "TaxFormula"
  end

  Factory.define :lic, :class => 'SalaryHead' do |s|
    s.name 'Insurance Policy'
    s.code  'insurance'
    s.tax_formula "TaxFormula"
  end

  Factory.define :loan, :class => 'SalaryHead' do |s|
    s.name 'Employee Loan'
    s.code  'loan'
    s.tax_formula "TaxFormula"
  end

  Factory.define :net, :class => 'SalaryHead' do |s|
    s.name 'Salary Slip Net'
    s.code  'net'
    s.salary_head_type 'SlipSubtotal'
    s.tax_formula "TaxFormula"
  end

  Factory.define :deduct, :class => 'SalaryHead' do |s|
    s.name 'Salary Slip Deduct'
    s.code  'deduct'
    s.salary_head_type 'SlipSubtotal'
    s.tax_formula "TaxFormula"
  end

  Factory.define :gross, :class => 'SalaryHead' do |s|
    s.name 'Salary Slip Gross'
    s.code  'gross'
    s.salary_head_type 'SlipSubtotal'
    s.tax_formula "TaxFormula"
  end

  Factory.define :extra_ctc, :class => 'SalaryHead' do |s|
    s.name 'Salary Slip CTC'
    s.code  'extra_ctc'
    s.salary_head_type 'SlipSubtotal'
    s.tax_formula "TaxFormula"
  end

  Factory.define :expense, :class => 'SalaryHead' do |s|
    s.name 'Employee Expense'
    s.code  'expense'
    s.tax_formula "TaxFormula"
  end

  def create_salary_heads
    Factory(:basic)
    Factory(:da)
    Factory(:dearness_relief)
    Factory(:med)
    Factory(:hra)
    Factory(:tvl)
    Factory(:laundry)
    Factory(:esi_employee_contrib)
    Factory(:esi_employer_contrib)
    Factory(:tds)
    Factory(:bonus)
    Factory(:adv)
    Factory(:lic)
    Factory(:loan)
    Factory(:net)
    Factory(:deduct)
    Factory(:gross)
    Factory(:extra_ctc)
    Factory :pension_admin_contrib
    Factory :pension_edli_contrib
    Factory :pension_inspection_contrib
    Factory :pf_employee_contrib
    Factory :epf_employer_contrib
    Factory :pension_fund_contrib
    Factory :voluntary_pf_contrib
    Factory(:expense)
  end
end