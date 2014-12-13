class ActiveSupport::TestCase
  
  Factory.define :package_for_developer, :class => 'EmployeePackage' do |s|
    s.employee {|e| e.association(:employee)}
    s.designation "Developer"
    s.start_date 2.years.ago
    s.basic 15000.00
    s.company {|e| e.association(:company)}
  end

  Factory.define :employee_package do |s|
    s.employee {|e| e.association(:employee)}
    s.sequence(:designation) {|n| "Designation_#{n}" }
    s.start_date 2.years.ago
    s.sequence(:basic){|n| 2000*n + 10000}
    s.company {|e| e.association(:company)}
  end

  Factory.define :employee_package_10000, :class => 'EmployeePackage' do |s|
    s.employee {|e| e.association(:employee)}
    s.sequence(:designation) {|n| "Designation_#{n}" }
    s.start_date 2.years.ago
    s.basic 10000.00
    s.company {|e| e.association(:company)}
  end
end