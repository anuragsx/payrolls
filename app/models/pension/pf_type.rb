class PfType < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  validates :name, :presence => true

  def descriptive_name
    "#{name} at #{pf_percent}%"
  end

  def pf_percent_multiplier
    (pf_percent < 1.0) ? pf_percent : pf_percent / 100.0
  end

  def effective_base_for_company(basic,da,dr=nil)
    0.0
  end

  def effective_base_for_employee(basic,da)
    effective_base_for_company(basic,da)
  end

  def employer_charges(effective_base_for_company=nil, vpf_amount=nil)
    []
  end
  
  def epf_contrib(effective_base)
    0
  end

  def admin_contrib(effective_base)
    0
  end

  def edli_contrib(effective_base)
    0
  end

  def inspection_contrib(effective_base)
    0
  end

  def employer_charges_for_sheet(effective_base)
    []
  end
  
  def employee_contrib(effective_base)
    (effective_base * effective_employee_percent / 100.0).round
  end
  memoize :employee_contrib

  def pension_contrib(effective_base)
    (effective_base * pension_percent / 100.0).round
  end

end
