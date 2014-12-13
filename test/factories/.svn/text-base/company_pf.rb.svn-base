class ActiveSupport::TestCase

  Factory.define :company_pf do |r|
    r.company {|c| c.association(:company)}
    r.pf_type {|c| c.association(:pf_type)}
    r.sequence(:pf_number) {|c| rand(199999)}
  end

  Factory.define :govt_company_pf, :class => :company_pf do |r|
    r.company {|c| c.association(:company)}
    r.pf_type {|c| c.association(:govt_pension)}
    r.sequence(:pf_number) {|c| rand(199999)}
  end

  Factory.define :private_company_pf, :class => :company_pf do |r|
    r.company {|c| c.association(:company)}
    r.pf_type {|c| c.association(:private_pension)}
    r.sequence(:pf_number) {|c| rand(199999)}
  end

end