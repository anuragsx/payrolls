module EmployeePackagesHelper

  def setup_ep(employee_package)
    @salary_heads = CompanyAllowanceHead.scoped_by_company_id(@company).collect{|ca| ca.salary_head}
    returning(employee_package) do |ep|
      if employee_package.employee_package_heads.blank?
        @salary_heads.each {|sh| employee_package.employee_package_heads.build(:salary_head => sh, :amount => 0,:company_id => @company.id, :employee_id => @employee.id)} unless @salary_heads.blank?
      end      
    end
  end
  
end
