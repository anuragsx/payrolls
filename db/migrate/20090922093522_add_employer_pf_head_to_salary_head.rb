class AddEmployerPfHeadToSalaryHead < ActiveRecord::Migration
  def self.up
    SalaryHead.create(:name => "Voluntary Employer PF Contribution", :code => "employer_vpf",:tax_formula=>'TaxFormula')
  end

  def self.down
  end
end
