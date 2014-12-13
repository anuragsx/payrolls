class AddTaxFormulaToMedicalHead < ActiveRecord::Migration
  def self.up
    begin
      SalaryHead.code_for_medical.update_attribute('tax_formula','MedicalReimbursementTaxFormula')
    rescue
      nil
    end
  end

  def self.down
  end
end
