class ActiveSupport::TestCase

  Factory.define :employee_tax do |r|
    r.company  {|c| c.association(:company)}
    r.employee  {|c| c.association(:employee)}
  end

end