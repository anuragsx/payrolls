class ActiveSupport::TestCase

  Factory.define :employee_insurance_policy do |r|
    r.company  {|c| c.association(:company)}
    r.employee  {|c| c.association(:employee)}
    r.sequence(:name) {|n| "Policy Name #{n}" }
    r.sequence(:monthly_premium) {|mp| 100 + mp }
    r.expiry_date Date.today + 365
  end

end