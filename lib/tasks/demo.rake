require 'salaree_helper'
include SalareeHelper
namespace :migrate do
  desc "Loads fake demo data"
  task :demo=>:environment do
    require 'populator'
      require 'faker'
      puts "Generating Company Data"
      #active_state = EmployeeStatus.find_by_name("Active").id
      company = Company.create(:name=>"Demo Pvt. Ltd.",:subdomain=>"demo",
                :package_id=>Package.find_by_max_employees(20).id,
                :rate_of_leave=>20,
                :bank=>"Satate bank Of India",
                :account_number=>Faker.numerify('#### #### ####'))
      u= User.new
      u.login = "demo"
      u.email = "admin@#{company.subdomain}.com"
      u.password = "demo"
      u.password_confirmation = "demo"
      u.company_id = company.id
      u.activate = true
      if u.save
        puts "User Created"
      else
        puts u.errors.to_a.join(" \n")
      end
      departments = []
      Department.populate 1..5 do |dept|
        dept.name = (Populator.words(3) + " Department").titleize
        dept.company_id = company.id
        departments << dept
      end
      under_company_size = Package.find(company.package_id).max_employees
      Employee.populate under_company_size.to_i do |e|
        e.name = Faker::Name.name
        e.status = 'active'
        e.company_id = company.id
        e.department_id = departments.rand.try(:id)
        e.commencement_date = 1.years.ago .. Time.now
        e.account_number = Faker.numerify('#### #### ####')
        EmployeePackage.populate 1 do |ep|
          ep.employee_id = e.id
          ep.designation = "Beginner"
          ep.start_date = e.commencement_date
          ep.basic = [30000,rand(50000)].max.to_f
          ep.company_id = company.id
          ep.end_date = Date.end_of_time
        end
        puts "Created company #{company.name}'s employee #{e.name}"
      end

      puts "Setup #{company.name}"
      pick_leave_manager(company)
      pick_package_manager(company)
      position = 3
      position = got_dearness_relief(company,position)
      position = got_pf(company,position)
      position = got_esi(company,position)
      position = got_pt(company,position)
      position = got_tds(company,position)
      position = got_insurance(company,position)
      position = got_loans(company,position)
      position = got_advances(company,position)
      position = got_expenses(company,position)
      position = got_bonus(company,position)
      position = got_gratuity(company,position)
  end

  desc "Load Company Salary Sheets"
  task :demo_salaries => ["migrate:demo"] do
      require 'populator'
      require 'faker'
      puts "Generating Salary Runs"
      company = Company.find_by_subdomain("demo")
      puts "Generating Salary Sheets for #{company.name}"
      year = 2009
      months = 1..6
      months.each do |mon|
        run_date = Date.new(year,mon,Time.days_in_month(mon,year))
        s = company.salary_sheets.build(:run_date => run_date)
        puts "\t for #{Time::RFC2822_MONTH_NAME[mon-1]} #{year} (#{s.eligible_employees.size} employees)"
        s.eligible_employees.each do |e|
          absent = [3,4,5,7].rand
          present = s.total_days_in_month - absent
          EmployeeLeave.create(:company => company, :created_at => s.run_date,
            :employee => e, :present => present, :absent => absent)
          rand(3).times do
            EmployeeAdvance.create(:company => company, :employee => e,
              :created_at => s.run_date, :amount => rand(1000),
              :description => "Advance given #{Populator.words(2)}")
          end
          if (rand(2) == 1)
            Reimbursement.create(:employee => e, :company => e.company,
              :amount => rand(500),
              :expensed_at => (run_date - rand(25).days),
              :description => 'Blah' )
            EmployeeTax.create(:employee => e,
                                 :company => company,
                                 :amount => 500,
                                 :description => "TDS cut #{Populator.words(2)}",
                                 :created_at => s.run_date - rand(25).days)
          else
            EmployeeTaxDetail.create(:employee => e, :company => company,
                                     :pan => Faker.numerify('############'),
                                     :tax_category => TaxCategory.all.rand)

          end
        end
        s.save!
        display_sheet(s)
        s.do_finalize!
        puts "Salary Sheet finalized!"
      end
  end
end