class ActiveSupport::TestCase
  
  Factory.define :silver_package, :class => :package do |r|
    r.name "Silver"
    r.code "SLVR"
    r.fee 1000.0
    r.max_employees 20
  end

  Factory.define :gold_package, :class => :package do |r|
    r.name "Gold"
    r.code "GOLD"
    r.fee 1500.0
    r.max_employees 50
  end

  Factory.define :platinum_package, :class => :package do |r|
    r.name "Platinum"
    r.code "PLTN"
    r.fee 2000.0
    r.max_employees 100
  end

  Factory.define :package do |r|
    r.sequence(:name) {|n| "package_#{n}" }
    r.sequence(:code) {|n| "code_#{n}" }
    r.fee 2000.0
    r.max_employees 100
  end

end