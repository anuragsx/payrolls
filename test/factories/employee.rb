class ActiveSupport::TestCase

  Factory.define :arun_employee, :class => "Employee" do |r|
    r.name "Arun Agrawal"
    r.company  {|c| c.association(:risingsun)}
    r.status "Active"
    r.commencement_date 2.years.ago
    r.sequence(:identification_number) {|n| "id#{n}"}
    r.address {|c| c.association(:address)}
  end

  Factory.define :pooja_employee, :class => "Employee" do |r|
    r.name "Pooja Gupta"
    r.company  {|c| c.association(:risingsun)}
    r.status "Active"
    r.commencement_date 1.years.ago
    r.sequence(:identification_number) {|n| "id#{n}"}
    r.address {|c| c.association(:address)}
  end

  Factory.define :rashmi_employee, :class => "Employee" do |r|
    r.name "Rashmi Yadav"
    r.company  {|c| c.association(:risingsun)}
    r.status "Active"
    r.commencement_date 1.years.ago
    r.sequence(:identification_number) {|n| "id#{n}"}
    r.address {|c| c.association(:address)}
  end

  Factory.define :employee do |r|
    r.sequence(:name) {|n| "employee_#{n}" }
    r.company  {|c| c.association(:company)}
    r.status "active"
    r.commencement_date 1.years.ago
    r.sequence(:identification_number) {|n| "id#{n}"}
    r.address {|c| c.association(:address)}
    r.department {|c| c.association(:department)}
  end  

end