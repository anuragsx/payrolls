class ActiveSupport::TestCase
  
  Factory.define :govt_pension, :class => 'GovtPension'  do |r|
    r.name "Govt. Municipality"
    r.pension_percent 8.33
    r.epf_percent 0
    r.pf_basic_threshold 999999999.00
  end

  Factory.define :private_pension, :class => 'PrivatePension'  do |r|
    r.name "Private Sector"
    r.pension_percent 8.33
    r.epf_percent 12.0-8.33
    r.pf_basic_threshold 6500.00
    r.admin_percent 1.1
    r.edli_percent 0.5
    r.inspection_percent 0.01
  end

  Factory.define :pf_type do |r|
    r.name "PF Type"
    r.pension_percent 8.33
    r.epf_percent 0
    r.pf_basic_threshold 999999999.00
  end

end