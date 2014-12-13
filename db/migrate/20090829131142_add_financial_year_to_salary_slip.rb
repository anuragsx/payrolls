class AddFinancialYearToSalarySlip < ActiveRecord::Migration
  def self.up
    add_column :salary_slips, :financial_year, :integer
    SalarySlip.reset_column_information
    SalarySlip.all.each{|sl| sl.update_attribute('financial_year', sl.salary_sheet.run_date.financial_year)}
  end

  def self.down
    remove_column :salary_slips, :financial_year
  end
end
