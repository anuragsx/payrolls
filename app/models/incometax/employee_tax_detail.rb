class EmployeeTaxDetail < ActiveRecord::Base
  belongs_to :employee
  belongs_to :company
  belongs_to :tax_category
  has_many :employee_investment_80cs, :dependent => :destroy

  YEARS = ((Date.today - 5.years).year..(Date.today + 5.years).year).to_a

  validates :employee, :company, :tax_category, :presence => true
 

  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  

#  def validate
#    unless self.class.for_employee(employee).for_financial_year(financial_year).blank?
#      errors.add_to_base("Employee tax details for #{financial_year} exist already")
#    end
#  end

  def description
    self.tax_category.category
  end

  def self.financial_years
    years = YEARS
    ar = []
    years.each do |year|
      ar << ["#{year}-#{year.next}",year]
    end
    ar
  end

#  def financial_year_formatted
#    "#{financial_year}-#{financial_year.next}"
#  end

  def tax_amount(earnings, dt)
    TaxSlab.tax_amount(tax_category,earnings, dt)
  end

  def self.pan_for_employee(employee)
    for_employee(employee).first.try(:pan)
  end

end
