class ActiveSupport::TestCase

  Factory.define :company_esi do |r|
    r.company {|c| c.association(:company)}
    r.esi_type {|c| c.association(:esi_type)}
    r.sequence(:esi_number) {|c| rand(199999)}
  end

  Factory.define :factory_company_esi, :class => :company_esi do |r|
    r.company {|c| c.association(:company)}
    r.esi_type {|c| c.association(:factory_esi)}
    r.sequence(:esi_number) {|c| rand(199999)}
  end

  Factory.define :shop_company_esi, :class => :company_esi do |r|
    r.company {|c| c.association(:company)}
    r.esi_type {|c| c.association(:shop_esi)}
    r.sequence(:esi_number) {|c| rand(199999)}
  end

end