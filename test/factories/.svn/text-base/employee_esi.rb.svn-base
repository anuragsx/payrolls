class ActiveSupport::TestCase

  Factory.define :employee_esi do |r|
    r.company  {|c| c.association(:company)}
    r.employee  {|c| c.association(:employee)}
    r.applicable true
    r.effective_date Date.today
  end

end