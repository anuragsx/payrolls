class ActiveSupport::TestCase

  Factory.define :company do |r|
    r.sequence(:name) {|n| "Company_#{n}" }
    r.sequence(:subdomain) {|n| "subdomain#{n}" }
    r.package {|p| p.association(:package)}
    r.pan "AIRPA8181"
    r.tan "9694333433"
    r.round_by 1
  end

  Factory.define :risingsun, :class => :company do |r|
    r.name "Risingsun"
    r.subdomain "risingsun"
    r.package {|p| p.association(:silver_package)}
    r.pan "AIRPA8181"
    r.tan "9694333433"
    r.round_by 1
  end

end