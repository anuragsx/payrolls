class ActiveSupport::TestCase

  Factory.define :employee_advance do |r|
    r.company  {|c| c.association(:company)}
    r.employee {|s| s.association(:employee)}
    r.sequence(:amount) {|n| 1200 + n}
    r.salary_slip {|s| s.association(:salary_slip)}
    r.created_at Date.today
  end

end