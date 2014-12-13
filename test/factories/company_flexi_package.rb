class ActiveSupport::TestCase
  
  Factory.define :company_flexi_package do |r|
    r.company {|c| c.association(:company)}
    r.salary_head {|c| c.association(:salary_head)}
    r.lookup_expression "Employee"
    r.sequence(:position) {|n| n+1}
  end
  
end