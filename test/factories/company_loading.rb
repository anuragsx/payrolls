class ActiveSupport::TestCase

  Factory.define :company_loading do |r|
    r.company {|c| c.association(:company)}
    r.sequence(:loading_percent) {|n| 20 + n}
  end

end