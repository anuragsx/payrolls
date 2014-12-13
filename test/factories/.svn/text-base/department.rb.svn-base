class ActiveSupport::TestCase

  Factory.define :department do |r|
    r.company {|c| c.association(:company)}
    r.sequence(:name) {|n| "Department_#{n}"}
 end

end