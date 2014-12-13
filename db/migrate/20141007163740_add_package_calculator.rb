class AddPackageCalculator < ActiveRecord::Migration
  def up
    AnnuallyEquatedTaxCalculator.create(:name => "Annually Equated Tax Calculator", :calculator_type => "Deduction")
  end

  def down
    AnnuallyEquatedTaxCalculator.first.destroy
  end
end
