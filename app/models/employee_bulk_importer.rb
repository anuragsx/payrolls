class EmployeeBulkImporter < SalareeExcelImporter

  def import
    company.transaction do
      employee_sheet = spreadsheet.worksheet("Employees")
      employees = []
      @errors = []
      department = company.departments.first
      company_pf = CompanyPf.find_by_company_id(company)
      company_esi = CompanyEsi.find_by_company_id(company)
      employee_sheet.each(1) do |row|
        employee = Employee.new(:name => row.at(0), :company => company,
                                :commencement_date => row.date(2), :department => department,
                                :identification_number => row.at(1))
        employee.build_address(:address_line1 => row.at(3),
                               :city => row.at(4))
        employee_package = EmployeePackage.new(:start_date => employee.commencement_date, :company => company,
                                               :designation => row.at(5), :basic => row.at(10))
        employee.employee_packages << employee_package
        # Currently we have only one Employee Package in excel file
        attrs = {:company => company, :employee => employee, :employee_package => employee_package}
        hra = EmployeePackageHead.new(attrs.merge(:salary_head => SalaryHead.code_for_rent, :amount => row.at(11)))
        med = EmployeePackageHead.new(attrs.merge(:salary_head => SalaryHead.code_for_medical, :amount => row.at(12)))
        tvl = EmployeePackageHead.new(attrs.merge(:salary_head => SalaryHead.code_for_conveyance, :amount => row.at(13)))
        spl = EmployeePackageHead.new(attrs.merge(:salary_head => SalaryHead.code_for_special_allowance, :amount => row.at(14)))

        employee_package.employee_package_heads << [hra, med, tvl, spl]
        tax_category = TaxCategory.find_by_category(row.at(7))
        tax_details = EmployeeTaxDetail.new(:employee => employee, :company => company, :pan => row.at(6), :tax_category => tax_category) if tax_category
        employees << employee
        Employee.transaction do
          employee.save!
          tax_details.save! if tax_category
          EmployeePension.create(:employee => employee, :company => company,
                                 :company_pf => company_pf,
                                 :epf_number => row.at(8).to_s,
                                 :created_at => employee.commencement_date) if company_pf && !row.at(8).blank?
          company_esi.create_for_employee(employee,employee.commencement_date, row.at(9).to_s) if company_esi && !row.at(9).blank?
        end
      end
      employee_leave_sheet = spreadsheet.worksheet("EmployeeLeaves")
      employee_leave_sheet.each(1) do |row|
        employee = company.employees.find_by_name(row.at(0))
        el = EmployeeLeave.build_object(company,employee,Date.parse(row.at(1)))
        el.present = row.at(2)
        el.absent = row.at(3)
        el.save!
      end
      return employees
    end
  end

end
