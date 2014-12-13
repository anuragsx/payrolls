class ActiveSupport::TestCase

  Factory.define :employee_leave_balance do |r|
    r.company  {|c| c.association(:company)}
    r.employee {|s| s.association(:employee)}
    r.financial_year Date.today.year
  end

end