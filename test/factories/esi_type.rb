class ActiveSupport::TestCase
  
  Factory.define :factory_esi, :class => 'EsiType'  do |r|
    r.name "Factory Act"
    r.employee_size 10
    r.employee_contrib_percent 1.75
    r.employer_contrib_percent 4.75
    r.basic_threshold 10000.00
  end

  Factory.define :shop_esi, :class => 'EsiType'  do |r|
    r.name "Shops Sector"
    r.employee_size 20
    r.employee_contrib_percent 1.75
    r.employer_contrib_percent 4.75
    r.basic_threshold 10000.00
  end

end