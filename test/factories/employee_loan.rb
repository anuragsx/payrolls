class ActiveSupport::TestCase

  Factory.define :employee_loan do |r|
    r.company  {|c| c.association(:company)}
    r.employee {|s| s.association(:employee)}
    r.sequence(:loan_amount) {|n| 1200 + n}
    r.created_at Date.today
  end

end