class ActiveSupport::TestCase

  Factory.define :employee_leave do |r|
    r.company  {|c| c.association(:company)}
    r.employee {|s| s.association(:employee)}
    r.present 0
    r.absent 0
    r.created_at Date.today
  end

end