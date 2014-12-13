class TaxSlab < ActiveRecord::Base

  attr_accessible :min_threshold, :max_threshold, :tax_rate, :financial_year

  belongs_to :tax_category
  scope :applied_slab, lambda{|e|{:conditions => ["min_threshold <= ?", e]}}
  scope :for_category, lambda{|e|{:conditions => ["tax_category_id = ?", e],
                                        :order => "max_threshold ASC" }}
  scope :order_by_financial_year, {:order => "financial_year DESC" }

  def self.tax_amount(category,earnings, dt)
    financial_year = dt.financial_year || Date.today.financial_year
    financial_year_is(financial_year).for_category(category).applied_slab(earnings).all.sum(0) do |s|
      ([(s.max_threshold || earnings.to_f),earnings.to_f].min - s.min_threshold) * (s.tax_rate / 100.0)
    end * (EDUCATION_CESS + 1.0)
  end

end
