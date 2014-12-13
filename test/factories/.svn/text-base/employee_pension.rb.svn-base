class ActiveSupport::TestCase

  Factory.define :employee_pension do |r|
    r.company  {|c| c.association(:company)}
    r.employee  {|c| c.association(:employee)}
    r.company_pf  {|c| c.association(:company_pf)}
    r.sequence(:epf_number) {|n| rand(n + 10000)}
    r.total_pf_contribution  0
    r.vpf_amount  0
    r.vpf_percent 0
    r.created_at Date.today
  end

end