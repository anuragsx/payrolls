class AddFinancialYearToSalarySheet < ActiveRecord::Migration
  def self.up
    add_column :salary_sheets, :financial_year, :integer
    SalarySheet.reset_column_information
    SalarySheet.all.each{|sh| sh.update_attribute('financial_year', sh.run_date.financial_year)}
  end

  def self.down
    remove_column :salary_sheets, :financial_year
  end
end
