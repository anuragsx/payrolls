class ActiveSupport::TestCase
  
  Factory.define :employee_package_head do |r|
    r.employee {|e| e.association(:employee)}
    r.employee_package {|e| e.association(:employee_package)}
    r.salary_head {|e| e.association(:salary_head)}
    r.company {|e| e.association(:company)}
    r.amount 500
  end

end