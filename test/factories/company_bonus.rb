class ActiveSupport::TestCase

  Factory.define :company_bonus do |r|
    r.company {|c| c.association(:company)}
    r.sequence(:bonus_percent) {|n| n + 1}
    r.release_date Date.today - 1.years
 end

end