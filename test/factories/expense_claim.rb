class ActiveSupport::TestCase

  Factory.define :expense_claim do |r|
    r.company  {|c| c.association(:company)}
    r.employee {|s| s.association(:employee)}
    r.sequence(:amount) {|n| 1200 + n}
    r.salary_slip {|s| s.association(:salary_slip)}
    r.expensed_at Date.today
    r.description "Descrition"
  end

end