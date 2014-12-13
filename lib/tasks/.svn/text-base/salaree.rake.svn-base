require 'salaree_helper'
include SalareeHelper
namespace :salaree do

  desc "Dangerous DO NOT USE in Production"
  task :bootup => ["db:migrate:reset","salaree:all"]

  desc "Load Companies"
  task :all => ["salaree:load:companies","salaree:load:salaries"] 
  namespace :load do
  
    desc "Load Company Salary Sheets"
    task :salaries  do
      require 'populator'
      require 'faker'
      puts "Generating Salary Runs"
      Company.all.each do |company|
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
              
            end

          end
          s.save!
          display_sheet(s)
          s.finalize!
          puts "Salary Sheet finalized!"
        end
      end
    end

    desc "Load Fake Companies"
    task :companies => :environment do
      require 'populator'
      require 'faker'
      puts "Generating Company Data"
      #active_state = EmployeeStatus.find_by_name("Active").id
      Company.populate 2 do |company|
        company.name = Faker::Company.name
        company.subdomain = Faker::Internet.domain_word
        company.package_id = Package.find(:first,:order => "RAND()").id
        company.rate_of_leave = [0,12,20]
        company.bank = ["State Bank of India", "SBBJ","Bank of Baroda", "Punjab National Bank",
          "Oriental Bank of Commerce","ICICI","Standard Chartered"]
        company.account_number = Faker.numerify('#### #### ####')
        u= User.new
        u.login = "#{company.subdomain}_admin"
        u.email = "admin@#{company.subdomain}.com"
        u.password = "admin123"
        u.password_confirmation = "admin123"
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
        under_company_size = rand(Package.find(company.package_id).max_employees)
        Employee.populate under_company_size do |e|
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
            ep.basic = 80000#[20000,rand(80000)].max.to_f
            ep.company_id = company.id
            ep.end_date = Date.end_of_time
          end
          puts "Created company #{company.name}'s employee #{e.name}"
          if true#rand(2)
            category = TaxCategory.all.rand
            [2008,2009].each do |year|
            EmployeeTaxDetail.create(:employee_id =>e.id, :company_id => company.id,
                                      :pan => Faker.numerify('############'),
                                      :tax_category => category,
                                      :financial_year=>year)
            end
          else
            EmployeeTax.create(:employee_id => e.id,
                                   :company_id => company.id,
                                   :amount => 500,
                                   :description => "TDS cut #{Populator.words(2)}",
                                   :created_at => (Date.new(2009,3,1)..Date.new(2009,6,30)).to_a.rand)
          end
        end
      end

      Company.all.each do |company|
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
    end
  end


end
