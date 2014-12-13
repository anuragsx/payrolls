class ActiveSupport::TestCase

  Factory.define :company_leave do |r|
    r.company {|c| c.association(:company)}
    r.rate_of_leave 20
    r.month_day_calculation 1
    r.month_length 30
    r.leave_accrual 1
  end

end