class AddAnnualTaxCalculator < ActiveRecord::Migration
  def self.up
    AnnuallyEquatedTaxCalculator.create(:name => "Annually Equated Tax Calculator", :calculator_type => "Deduction")
  end

  def self.down
    AnnuallyEquatedTaxCalculator.first.destroy
  end
end
