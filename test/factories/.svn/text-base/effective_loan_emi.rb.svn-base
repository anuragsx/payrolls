class ActiveSupport::TestCase

  Factory.define :effective_loan_emi do |r|
    r.employee_loan  {|c| c.association(:employee_loan)}
    r.employee  {|c| c.association(:employee)}
    r.sequence(:amount) {|n| 100 + n}
    r.created_at Date.today
  end

end