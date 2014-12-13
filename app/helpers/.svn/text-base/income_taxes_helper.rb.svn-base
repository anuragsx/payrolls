module IncomeTaxesHelper
  def fetch_income_bracket(slab)
    prefix = "#{slab.min_threshold.to_i}"
    suffix = slab.max_threshold.nil? ? "and above" : "#{t('common.to')} #{slab.max_threshold.to_i}"
    "#{prefix} #{suffix}"
  end
end
