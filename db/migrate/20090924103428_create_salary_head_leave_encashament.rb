class CreateSalaryHeadLeaveEncashament < ActiveRecord::Migration
  def self.up
    begin
      SalaryHead.create(:name => "Leave Encashment", :code => "encashment", :tax_formula => "TaxFormula")
    rescue
      nil
    end
  end

  def self.down
  end
end
