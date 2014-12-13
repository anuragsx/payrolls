class ActiveSupport::TestCase

  Factory.define :tax_slab do |r|
    r.min_threshold  0
    r.max_threshold  190000
    r.tax_rate 10
    r.tax_category {|e| e.association(:tax_category)}
  end

end