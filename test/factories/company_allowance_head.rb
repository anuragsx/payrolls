class ActiveSupport::TestCase
  
  Factory.define :company_allowance_head do |r|
    r.company {|c| c.association(:company)}
    r.salary_head {|c| c.association(:salary_head)}
    r.sequence(:position) {|n|  n}
  end
  
  Factory.define :hra_company_allowance_head, :class => "CompanyAllowanceHead" do |r|
    r.company {|c| c.association(:company)}
    r.salary_head {|c| c.association(:hra)}
    r.sequence(:position) {|n|  n}
  end

  Factory.define :da_company_allowance_head, :class => "CompanyAllowanceHead" do |r|
    r.company {|c| c.association(:company)}
    r.salary_head {|c| c.association(:da)}
    r.sequence(:position) {|n|  n}
  end
end