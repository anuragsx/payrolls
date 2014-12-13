class ActiveSupport::TestCase

  Factory.define :employee_investment80c do |r|
    r.company  {|c| c.association(:company)}
    r.employee  {|c| c.association(:employee)}
    r.employee_investment_scheme  {|c| c.association(:employee_investment_scheme)}
    r.amount 1000
    r.financial_year Date.today.year
    r.employee_tax_detail {|c| c.association(:employee_tax_detail)}
    r.created_at Date.today
  end

end