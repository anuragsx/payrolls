class ActiveSupport::TestCase

  Factory.define :bank do |r|
    r.company {|c| c.association(:company)}
    r.sequence(:company_account_number) {|n| "000111#{n}"}
    r.sequence(:name) {|n| "bank_name_#{n}"}
    r.address {|c| c.association(:address)}
 end

end