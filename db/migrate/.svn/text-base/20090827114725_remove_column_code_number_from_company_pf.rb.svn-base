class RemoveColumnCodeNumberFromCompanyPf < ActiveRecord::Migration
  def self.up
    CompanyPf.all.each do |cpf|
      cpf.update_attribute(:pf_number,cpf.code_no)
    end
    remove_column(:company_pfs, :code_no)
  end

  def self.down
    add_column(:company_pfs, :code_no, :string)
  end
end