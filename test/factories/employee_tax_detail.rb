class ActiveSupport::TestCase

  Factory.define :employee_tax_detail do |r|
    r.company  {|c| c.association(:company)}
    r.employee  {|c| c.association(:employee)}
    r.tax_category  {|c| c.association(:tax_category)}
    r.pan "12345678"    
  end
end