class AddLabourWelfareSeedData < ActiveRecord::Migration
  def self.up
    SalaryHead.create(:name => "LWF Employee Contribution", :code => "LWF_EMPLOYEE",:tax_formula=>'TaxFormula')
    SalaryHead.create(:name => "LWF Employer Contribution", :code => "LWF_EMPLOYER",:tax_formula=>'TaxFormula')
    LabourWelfareCalculator.create(:name => "Labour Welfare", :calculator_type => 'Deduction')
  end

  def self.down
  end
end
