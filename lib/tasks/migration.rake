require 'salaree_helper'
#require 'spreadsheet/excel'
require 'spreadsheet'
include SalareeHelper

# Get access to the worksheets instance variable
def company_create(company_sheet)
  company_vals = {}
  company_sheet.each do |row|
    company_vals[row.at(0).to_sym] = row.at(1)
  end
  Company.create!(company_vals)
end

def department_create(workbook,company)
  depts_sheet = workbook.worksheet("Departments")
  departments = {}
  depts_sheet.map do |row|
    name = row.at(0)
    departments[name] = Department.create(:name => name, :company => company)
  end
  departments
end

def load_company_pf(workbook,company)
  pf_sheet = workbook.worksheet("CompanyPf")
  pf_type = pf_sheet.row(0).at(0)
  p pf_type
  pf = PfType.find_by_type(pf_type)
  CompanyPf.create(:company=>company, :pf_type=>pf,:pf_number=>"pfnumber")
end

def load_company_esi(workbook,company)
  esi_sheet = workbook.worksheet("CompanyEsi")
  esi_type = esi_sheet.row(0).at(0)
  p esi_type
  esi = EsiType.find_by_name(esi_type)
  CompanyEsi.create(:company=>company, :esi_type=>esi,:esi_number=>"esinumber")
end

def company_user_create(company)
  u = User.new
  u.login = "#{company.subdomain}_admin"
  u.email = "admin@#{company.subdomain}.com"
  u.password = "admin123"
  u.password_confirmation = "admin123"
  u.company = company
  u.activate = true
  if u.save
    puts "User Created"
  else
    puts u.errors.to_a.join(" \n")
  end
end

def create_company_employees(employee_sheet,company,departments)
  #active_state = EmployeeStatus.find_by_name("Active")
  employees = {}
  employee_sheet.each(1) do |row|
    e = company.employees.build
    e.name = row.at(0)
    e.status = 'active'
    e.company = company
    e.department = departments[row.at(1)]
    e.commencement_date = row.at(2)
    e.employee_packages_attributes = [{:designation => row.at(3),
        :start_date => e.commencement_date,
        :company => company,
        :basic => row.at(4).to_f}]
    e.save!
    puts "Created company #{company.name}'s employee #{e.name}"
    employees[e.name] = e
  end
  employees
end

def create_calculators(calculator_sheet,company)
  company.company_calculators.delete_all
  calculator_sheet.each_with_index do |row,i|
    cal = row.at(0)
    CompanyCalculator.create!(:company => company,
      :calculator => cal.constantize.first,
      :position => i + 1)
  end
end

def load_policies(workbook,company,employees)
  policies_sheet = workbook.worksheet("Policies")
  policies_sheet.each(1) do |row|
    name = row.at(0)
    puts "Processing policy for #{name}"
    attrs = {}
    attrs[:employee] = employees[name]
    attrs[:company] = company
    attrs[:name] = row.at(1)
    attrs[:monthly_premium] = row.at(2).to_f
    attrs[:created_at] = row.at(3)
    attrs[:expiry_date]= row.at(4)
    EmployeeInsurancePolicy.create!(attrs)
  end
end

def load_flexible_allowances(workbook,company)
  @heads = SalaryHead.all
  flexible_allowances_sheet = workbook.worksheet("CompanyFlexiPackage")
  flexible_allowances_sheet.each do |row|
    attrs = {}
    attrs[:company] = company
    sh = row.at(0)
    attrs[:salary_head] = @heads.detect{|d|d.code == sh}
    attrs[:lookup_expression] = row.at(1)
    attrs[:position] = row.at(2).to_i
    @cfp = CompanyFlexiPackage.create!(attrs)
  end
  flexible_allowances_sheet = workbook.worksheet("FlexibleAllowances")
  flexible_allowances_sheet.each(1) do |row|
    category_type = row.at(0)
    puts "Creating #{category_type}"
    attrs = {}
    attrs[:company] = company
    value = row.at(1)
    attrs[:category] = category_type.constantize.try(:find_by_name,value) || value
    attrs[:head_type] = row.at(2)
    sh = row.at(3)
    attrs[:salary_head] = @heads.detect{|d|d.code == sh}
    attrs[:leave_dependent] = row.at(4) == 'TRUE'
    attrs[:value] = row.at(5).to_f
    attrs[:company_flexi_package] =
      CompanyFlexiPackage.find_by_company_id_and_lookup_expression_and_salary_head_id(company.id,category_type, attrs[:salary_head].id)
    FlexibleAllowance.create!(attrs)
  end
end

def load_dearness_relief(workbook,company)
  dearness_relief_sheet = workbook.worksheet("DearnessRelief")
  dearness_relief_sheet.each(1) do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:created_at] = row.at(0)
    attrs[:loading_percent] = row.at(1).to_f
    CompanyLoading.create!(attrs)
  end
end

def load_pension_changes(workbook,company,employees)
  pensions_sheet = workbook.worksheet("PensionOverride")
  pensions_sheet.each do |row|
    employee = employees[row.at(0)]
    vpf_amount = row.at(1).to_f
    effective_date = row.at(2)
    pf = CompanyPf.for_company(company).first
    pf.employee_pensions.create(:employee => employee, :created_at => effective_date,
      :company => company, :vpf_amount => vpf_amount)
  end
end


def load_loans(workbook,employees)
  loans_sheet = workbook.worksheet("EmployeeLoans")
  loans_sheet.each(1) do |row|
    attrs = {}
    attrs[:employee] = employees[row.at(0)]
    attrs[:company] = attrs[:employee].company
    attrs[:loan_amount] = row.at(1).to_f
    attrs[:created_at] = row.at(3)
    attrs[:effective_loan_emis_attributes] = [{:amount => row.at(2).to_f,
        :employee => attrs[:employee],
        :created_at => attrs[:created_at]}]
    EmployeeLoan.create!(attrs)
  end
end

def load_loan_changes(workbook,employees)
  loans_sheet = workbook.worksheet("EMIChanges")
  loans_sheet.each do |row|
    attrs = {}
    attrs[:employee] = employees[row.at(0)]
    attrs[:amount] = row.at(1).to_f
    attrs[:created_at] = row.at(2)
    attrs[:employee_loan] = EmployeeLoan.for_employee(attrs[:employee]).first
    EffectiveLoanEmi.create(attrs)
  end
end


def load_promotions(workbook,employees)
  promotions_sheet = workbook.worksheet("Promotions")
  promotions_sheet.each(1) do |row|
    attrs = {}
    employee = employees[row.at(0)]
    attrs[:start_date] = row.at(1)
    attrs[:basic] = row.at(2).to_f
    employee.promote!(attrs)
  end
end

def load_company_allowances(workbook,company)
  CompanyAllowanceHead.for_company(company).delete_all
  company_allowance_sheet = workbook.worksheet("CompanyAllowance")
  company_allowance_sheet.each do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:salary_head] = SalaryHead.find_by_code(row.at(0))
    attrs[:position] = row.at(1)
    CompanyAllowanceHead.create(attrs)
  end
end

def load_employee_advances(company, employees, workbook)
  advance_sheet = workbook.worksheet("EmployeeAdvance")
  advance_sheet.each(1) do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:employee] = employees[row.at(0)]
    attrs[:amount] = row.at(1).to_f
    attrs[:created_at] = row.at(2)
    attrs[:description] = "Advance"
    EmployeeAdvance.create(attrs)
  end
end

def load_employee_leaves(workbook,company,employees)
  leave_register =  workbook.worksheet("EmployeeLeaves")
  leave_register.each do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:employee] = employees[row.at(0)]
    attrs[:present] = row.at(1).to_f
    attrs[:absent] = row.at(2).to_f
    attrs[:created_at] = row.at(3)

    EmployeeLeave.create(attrs)
  end
end

def load_employee_leave_balance(workbook,company,employees)
  leave_balance_sheet = workbook.worksheet("EmployeeLeaveBalance")
  leave_balance_sheet.each(1) do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:employee] = employees[row.at(0)]
    attrs[:financial_year] = row.at(1).to_i
    attrs[:opening_balance] = row.at(2).to_f
    attrs[:current_balance] = row.at(2).to_f
    attrs[:earned_leaves] = attrs[:spent_leaves] = 0

    EmployeeLeaveBalance.create(attrs)
  end
end

#useful only for skm
def load_skm_employee_package(workbook,company,employees)
  package_sheet = workbook.worksheet("EmployeePackage")
  heads = [SalaryHead.code_for_rent,SalaryHead.code_for_da,SalaryHead.code_for_adhoc,SalaryHead.code_for_conveyance]
  package_sheet.each(1) do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:employee] = employees[row.at(0)]
    attrs[:employee_package] = EmployeePackage.find_by_employee_id(employees[row.at(0)],:conditions=>['start_date = ?',row.at(5)])
    (0..3).each do |i|
      attrs[:salary_head] = heads[i]
      attrs[:amount] = row.at(i+1).to_f
      attrs[:leave_dependent] = true
      EmployeePackageHead.create(attrs)
    end
  end
end

def load_sksupl_employee_package(workbook,company,employees)
  package_sheet = workbook.worksheet("EmployeePackage")
  heads = [SalaryHead.code_for_rent,SalaryHead.code_for_special_allowance,SalaryHead.code_for_conveyance,SalaryHead.code_for_medical]
  package_sheet.each(1) do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:employee] = employees[row.at(0)]
    attrs[:employee_package] = EmployeePackage.find_by_employee_id(employees[row.at(0)],:conditions=>['start_date = ?',row.at(5)])
    (0..3).each do |i|
      attrs[:salary_head] = heads[i]
      attrs[:amount] = row.at(i+1).to_f
      attrs[:leave_dependent] = true
      EmployeePackageHead.create(attrs)
    end
  end
end

def load_skupl_employee_package(workbook,company,employees)
  package_sheet = workbook.worksheet("EmployeePackage")
  heads = [SalaryHead.code_for_rent,SalaryHead.code_for_da,SalaryHead.code_for_conveyance,SalaryHead.code_for_medical]
  package_sheet.each(1) do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:employee] = employees[row.at(0)]
    attrs[:employee_package] = EmployeePackage.find_by_employee_id(employees[row.at(0)],:conditions=>['start_date = ?',row.at(5)])
    (0..3).each do |i|
      attrs[:salary_head] = heads[i]
      attrs[:amount] = row.at(i+1).to_f
      attrs[:leave_dependent] = true
      EmployeePackageHead.create(attrs)
    end
  end
end

def load_pensions(workbook,company,employees)
  pensions_sheet = workbook.worksheet("Pensions")
  type = pensions_sheet.row(0).at(0)
  pf_number = pensions_sheet.row(0).at(1)
  pf = CompanyPf.create(:company => company, :pf_number => pf_number, :pf_type => PfType.find_by_type(type))
  pensions_sheet.each(2) do |row|
    vpf_amount = row.at(1).to_f
    pf.employee_pensions.create(:employee => employees[row.at(0)],
      :created_at => row.at(2),
      :company => company, :vpf_amount => vpf_amount)
  end
end


def load_employee_esi(workbook,company,employees)
  esi_sheet = workbook.worksheet("EmployeeEsi")
  type = esi_sheet.row(0).at(0)
  esi_number = esi_sheet.row(0).at(1)
  esi = CompanyEsi.create(:company => company, :esi_number => esi_number, :esi_type => EsiType.find_by_name(type))
  esi_sheet.each(2) do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:employee] = employees[row.at(0)]
    attrs[:effective_date] = row.at(1).to_date
    attrs[:applicable] = true
    EmployeeEsi.create(attrs)
  end
end

def company_leave_create(workbook, company)
  company_leave_sheet = workbook.worksheet("CompanyLeave")
  company_vals = {}
  company_leave_sheet.each do |row|
    company_vals[row.at(0).to_sym] = row.at(1)
  end
  company_vals[:company_id] = company.id

  CompanyLeave.create!(company_vals)
end

def employee_tax(workbook,company,employees)
  employee_tax_sheet = workbook.worksheet("EmployeeTax")
  employee_tax_sheet.each(1) do |row|
    attrs = {}
    attrs[:company] = company
    attrs[:employee] = employees[row.at(0)]
    attrs[:amount]= row.at(1)
    attrs[:created_at]= row.at(2)
    attrs[:description]= "Tax"

    EmployeeTax.create(attrs)
  end

end

def update_employees_package(workbook,company)
  emp_update_sheet = workbook.worksheet("EmployeeUpdates")
  emps = company.employees
  emp_update_sheet.each do |row|
    emps.each do |e|
      if e.name == row.at(0)
        em_pk = e.effective_package(row.at(2).to_date)
        em_pk.end_date = row.at(2)
        em_pk.save
        break
      end
    end
  end
end

namespace :migrate do
  
  desc "Load Uniara Data"
  task :uniara => :environment do
    #Open the excel file passed in from the commandline
    puts "Parsing Uniara Directory"
    workbook = Spreadsheet.open("#{RAILS_ROOT}/db/uniara.xls")
    company_sheet = workbook.worksheet('Company')
    company = company_sheet && company_create(company_sheet)
    company && company_user_create(company)
    puts "Loading Departments"
    departments = department_create(workbook,company)
    employee_sheet = workbook.worksheet('Employees')
    employees = employee_sheet && create_company_employees(employee_sheet,company,departments)
    calculators = workbook.worksheet('Calculators')
    calculators && create_calculators(calculators,company)
    puts "Loading Company Allowance"
    load_company_allowances(workbook, company)
    puts "Loading Policies"
    load_policies(workbook,company,employees)
    puts "Loading Dearness Relief"
    load_dearness_relief(workbook,company)
    puts "Loading Pensions"
    load_pensions(workbook,company,employees)
    puts "Loading Pension changes"
    load_pension_changes(workbook,company,employees)
    puts "Loading Loans"
    load_loans(workbook,employees)
    puts "Loading Loan EMI Changes"
    load_loan_changes(workbook,employees)
    puts "Loading Promotions"
    load_promotions(workbook,employees)
    puts "Loading Package Managers"
    load_flexible_allowances(workbook,company)
    puts "Update Employees Package"
    update_employees_package(workbook,company)
    puts "Loading Employee investment Schemes"

  end

  desc "Uniara Salary Runs"
  task :uniara_salaries => ["migrate:uniara"] do
    company = Company.find_by_subdomain("uniara")
    run_date = Date.new(2008,1,1).end_of_month
    s = company.salary_sheets.build(:run_date => run_date)
    s.save!
    display_sheet(s)
    run_date = Date.new(2008,5,1).end_of_month
    s = company.salary_sheets.build(:run_date => run_date)
    s.save!
    display_sheet(s)
    run_date = Date.new(2008,12,1).end_of_month
    s = company.salary_sheets.build(:run_date => run_date)
    s.save!
    display_sheet(s)
    s.finalize!
    run_date = Date.new(2009,2,1).end_of_month
    s = company.salary_sheets.build(:run_date => run_date)
    s.save!
    display_sheet(s)
    s.finalize!
    run_date = Date.new(2009,7,1).end_of_month
    s = company.salary_sheets.build(:run_date => run_date)
    s.save!
    display_sheet(s)
    s.finalize!
  end

  desc "Loads Shre Krshna Motors data"
  task :skm=>:environment do
    puts "Parsing SKM Directory"
    workbook = Spreadsheet.open("#{RAILS_ROOT}/db/skm.xls")
    company_sheet = workbook.worksheet('Company')
    company = company_sheet && company_create(company_sheet)
    company && company_user_create(company)
    puts "Loading Departments"
    departments = department_create(workbook,company)
    employee_sheet = workbook.worksheet('Employees')
    employees = employee_sheet && create_company_employees(employee_sheet,company,departments)
    calculators = workbook.worksheet('Calculators')
    calculators && create_calculators(calculators,company)
    company_leave_create(workbook, company)
    puts "Loading Leave Balances"
    load_employee_leave_balance(workbook,company,employees)
    puts "Loading Pensions"
    load_pensions(workbook,company,employees)
    puts "Loading Pension changes"
    load_pension_changes(workbook,company,employees)
    puts "Loading Promotions"
    load_promotions(workbook,employees)
    puts "Loading Company Allowance"
    load_company_allowances(workbook, company)
    puts "Loading Employee Advances"
    load_employee_advances(company, employees, workbook)
    puts "Loading Employee Leaves"
    load_employee_leaves(workbook,company,employees)
    puts "Loading Employee Esi"
    load_employee_esi(workbook,company,employees)
    puts "Loading Employee Package"
    load_skm_employee_package(workbook,company,employees)
    puts "Update Employees Package"
    update_employees_package(workbook,company)
    puts "Loading Employee investment Schemes"

  end

  desc "Skm Salary Runs"
  task :skm_salaries => ["migrate:skm"] do
    year = 2008
    months = 1..12
    company = Company.find_by_subdomain("skm")
    months.each do |mon|
      run_date = Date.new(year,mon,Time.days_in_month(mon,year))
      s = company.salary_sheets.build(:run_date => run_date)
      s.save!
      display_sheet(s)
    end
    cl = CompanyLeave.find_by_company_id(company.id)
    cl.carry_forward_leave_balances!(2008,2009)
    year = 2009
    months = 1..7
    months.each do |mon|
      if mon == 1
        e = Employee.find_by_name("Shailesh Saxena")
        lb = EmployeeLeaveBalance.find_by_employee_id(e.id ,:conditions => "financial_year =2009")
        lb.current_balance = 1
        lb.opening_balance = 1
        lb.spent_leaves = 0
        lb.earned_leaves = 0
        lb.save!
      end

      if mon == 7
        e = Employee.find_by_name("Shailesh Saxena")
        lb = EmployeeLeaveBalance.find_by_employee_id(e.id ,:conditions => "financial_year =2009")
        lb.current_balance = 5
        lb.opening_balance = 6
        lb.spent_leaves = 1
        lb.earned_leaves =1
        lb.save!
      end
      run_date = Date.new(year,mon,Time.days_in_month(mon,year))      
      s = company.salary_sheets.build(:run_date => run_date)
      
      s.save!
      display_sheet(s)
    end
  end


  desc "Loads Shre Krshna Sudarshan urja  data"
  task :sksupl =>:environment do
    puts "Parsing SKSUPL Directory"
    workbook = Spreadsheet.open("#{RAILS_ROOT}/db/sksupl.xls")
    company_sheet = workbook.worksheet('Company')
    company = company_sheet && company_create(company_sheet)
    company && company_user_create(company)
    puts "Loading Departments"
    departments = department_create(workbook,company)
    employee_sheet = workbook.worksheet('Employees')
    employees = employee_sheet && create_company_employees(employee_sheet,company,departments)
    calculators = workbook.worksheet('Calculators')
    calculators && create_calculators(calculators,company)
    puts "Loading Pensions"
    load_pensions(workbook,company,employees)
    puts "Loading Pension changes"
    #load_pension_changes(workbook,company,employees)
    puts "Loading Promotions"
    load_promotions(workbook,employees)
    puts "Loading Company Allowance"
    load_company_allowances(workbook, company)
    puts "Loading Employee Advances"
    load_employee_advances(company, employees, workbook)
    puts "Loading Employee Leaves"
    load_employee_leaves(workbook,company,employees)
    puts "Loading Employee Esi"
    load_employee_esi(workbook,company,employees)
    puts "Loading Employee Package"
    load_sksupl_employee_package(workbook,company,employees)
    puts "Update Employees Package"
    update_employees_package(workbook,company)
    puts "Loading Employee investment Schemes"
  end

  desc "Sksupl Salary Runs"
  task :sksupl_salaries => ["migrate:sksupl"] do
    year = 2008
    months = 1..12
    months.each do |mon|
      run_date = Date.new(year,mon,Time.days_in_month(mon,year))
      company = Company.find_by_subdomain("sksupl")
      s = company.salary_sheets.build(:run_date => run_date)
      s.save!
      display_sheet(s)
    end
    year = 2009
    months = 1..7
    months.each do |mon|
      run_date = Date.new(year,mon,Time.days_in_month(mon,year))
      company = Company.find_by_subdomain("sksupl")
      s = company.salary_sheets.build(:run_date => run_date)
      s.save!
      display_sheet(s)
    end
  end

  desc "Loads Shre Krshna urja  data"
  task :skupl =>:environment do
    puts "Parsing SKUPL Directory"
    workbook = Spreadsheet.open("#{RAILS_ROOT}/db/skupl.xls")
    company_sheet = workbook.worksheet('Company')
    company = company_sheet && company_create(company_sheet)
    company && company_user_create(company)
    puts "Loading Departments"
    departments = department_create(workbook,company)
    employee_sheet = workbook.worksheet('Employees')
    employees = employee_sheet && create_company_employees(employee_sheet,company,departments)
    calculators = workbook.worksheet('Calculators')
    calculators && create_calculators(calculators,company)
    company_leave_create(workbook, company)   
    puts "Loading Pensions"
    load_pensions(workbook,company,employees)
    puts "Loading Pension changes"
    #load_pension_changes(workbook,company,employees)
    puts "Loading Promotions"
    load_promotions(workbook,employees)
    puts "Loading Company Allowance"
    load_company_allowances(workbook, company)
    puts "Loading Employee Advances"
    load_employee_advances(company, employees, workbook)
    puts "Loading Employee Leaves"
    load_employee_leaves(workbook,company,employees)
    puts "Load Employee Tax"
    employee_tax(workbook,company,employees)
    puts "Loading Employee Package"
    load_skupl_employee_package(workbook,company,employees)
    puts "Update Employees Package"
    update_employees_package(workbook,company)
    puts "Loading Employee Esi"
    load_employee_esi(workbook,company,employees)
    puts "Loading Employee investment Schemes"
  end

  desc "Skupl Salary Runs"
  task :skupl_salaries => ["migrate:skupl"] do
    year = 2008
    months = 1..12
    months.each do |mon|
      run_date = Date.new(year,mon,Time.days_in_month(mon,year))
      company = Company.find_by_subdomain("skupl")
      s = company.salary_sheets.build(:run_date => run_date)
      s.save!
      display_sheet(s)
    end
    year = 2009   
    months = 1..7
    months.each do |mon|
      run_date = Date.new(year,mon,Time.days_in_month(mon,year))
      company = Company.find_by_subdomain("skupl")
      s = company.salary_sheets.build(:run_date => run_date)
      s.save!
      display_sheet(s)
    end
  end

  desc "Loads Rising Sun Technologies  data"
  task :rstpl =>:environment do
    puts "Parsing Rising Sun Technologies Directory"
    workbook = Spreadsheet.open("#{RAILS_ROOT}/db/rising_sun.xls")
    puts "Total #{workbook.worksheets.size} found"
    workbook.worksheets.each do |ws|
      puts ws.name
      puts ws.row_count
    end
    company_sheet = workbook.worksheet('Company')
    company = company_sheet && company_create(company_sheet)
    company && company_user_create(company)
    puts "Loading Departments"
    departments = department_create(workbook,company)
    employee_sheet = workbook.worksheet('Employees')
    employees = employee_sheet && create_company_employees(employee_sheet,company,departments)
    calculators = workbook.worksheet('Calculators')
    calculators && create_calculators(calculators,company)
    company_leave_create(workbook, company)
    puts "Loading Leave Balances"
    load_employee_leave_balance(workbook,company,employees)    
    puts "Loading Promotions"
    load_promotions(workbook,employees)
    puts "Loading Company Allowance"
    load_company_allowances(workbook, company)
    puts "Loading Employee Advances"
    load_employee_advances(company, employees, workbook)
    puts "Loading Employee Leaves"
    load_employee_leaves(workbook,company,employees)
    puts "Loading Employee Esi"
    load_employee_esi(workbook,company,employees)
    puts "Loading Employee Package"
    load_sksupl_employee_package(workbook,company,employees)
    puts "Update Employees Package"
    update_employees_package(workbook,company)
    puts "Loading Employee investment Schemes"
  end

  desc "Skupl Salary Runs"
  task :rstpl_salaries => ["migrate:rstpl"] do
    year = 2009
    months = [7]
    months.each do |mon|
      run_date = Date.new(year,mon,Time.days_in_month(mon,year))
      company = Company.find_by_subdomain("rstpl")
      s = company.salary_sheets.build(:run_date => run_date)
      s.save!
      display_sheet(s)
    end
  end
  
  desc "Create and attache pdf with sheets and slips for migrated data"
  task :create_and_attache_pdf =>:environment do
    Company.all.each do |company|
      company.salary_sheets.each do |s|
        s.update_attributes({:status => 'initial'})
        s.do_finalize! if !s.is_finalized?
        SalaryProcess.send_later(:salary_sheet_generator,s)
        s.salary_slips.each do |slip|
          SalaryProcess.send_later(:salary_slip_generator,slip)
        end
      end
    end
  end
  desc "Load Attendance type"
  task :load_attendance_type =>:environment do
    AttendanceType.create!(:name => "Present",:type => AttendanceType::PRESENT)
    AttendanceType.create!(:name => "Absent without Leave",:type => AttendanceType::ABSENT)
    AttendanceType.create!(:name => "Casual Leave",:type => AttendanceType::CASUAL_LEAVE)
    AttendanceType.create!(:name => "Privilege Leave",:type => AttendanceType::PRIVILEGE_LEAVE)
    AttendanceType.create!(:name => "Sick leave",:type =>  AttendanceType::SICK_LEAVE )
  end

  desc "check Leave Balances"
  task :check_leave_balances =>:environment do
    Company.all.each do |c|
      c.employees.each do |e|
        elb = EmployeeLeaveBalance.for_company(c).for_employee(e).group_by(&:financial_year)
        elb.keys.each do |k|
          eb = elb[k].group_by(&:leave_type)
          eb.keys.each do |t|
            if eb[t].size > 1
              eb[t].each_with_index do |d,i|
                unless i == 0
                   puts "My company is #{c.subdomain} id: #{c.id}"
                   p d
                end
              end
            end

          end
        end
      end
    end
#    cl = CompanyLeave.find_by_company_id(c)
#    if cl
#      c.employees.each do |e|
#        EmployeeLeaveBalance.employee_added!(e,cl.accrue_as_you_go?)
#      end
#    end
#    c.employees.each do |e|
#      p "Employee not have leave balance #{e.name}" if EmployeeLeaveBalance.find_all_by_employee_id(e).blank?
#      EmployeeLeaveType::LEAVE_TYPES.each do |leave_type|
#        elb = EmployeeLeaveBalance.for_employee(e).for_type(leave_type)
#        abc = CompanyLeave.find_by_company_id(c).accrue_as_you_go? ? elb.no_financial_year.last : elb.for_financial_year(run_date.year).last
#        p abc if abc.blank?
#      end
#    end
  end



end