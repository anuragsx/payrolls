class AddMatchCompanyVpfToEmployeePensions < ActiveRecord::Migration
  def self.up
    add_column :employee_pensions, :match_company_vpf, :boolean, :default => false
  end

  def self.down
    remove_column :employee_pensions, :match_company_vpf
  end
end
