class CompanyCalculator < ActiveRecord::Base

  attr_accessible :company, :calculator, :position, :company_id, :calculator_id

  belongs_to :company
  belongs_to :calculator


  #validates_presence_of :company_id, :calculator_id, :position
  validates :company_id, :calculator_id, :position, :presence => true

  #validates_uniqueness_of :company_id, :scope => :calculator_id
  validates :company_id, :uniqueness => {:scope => :calculator_id}

  #TODO can check the result later
  #scope :by_leave, :conditions=>["calculators.calculator_type = ?",'Leave'],:joins =>:calculator
  #scope :by_package, :conditions=>["calculators.calculator_type = ?",'Package'],:joins =>:calculator
  #scope :by_allowance, :conditions=>["calculators.calculator_type = ?",'Allowance'],:joins =>:calculator
  #scope :by_deduction, :conditions=>["calculators.calculator_type = ?",'Deduction'],:joins =>:calculator
  #scope :by_subtotal, :conditions=>["calculators.calculator_type = ?",'Subtotal'],:joins =>:calculator


  scope :by_leave, :conditions=>["calculators.calculator_type = ?",'Leave'],:joins =>:calculator
  scope :by_package, :conditions=>["calculators.calculator_type = ?",'Package'],:joins =>:calculator
  scope :by_allowance, :conditions=>["calculators.calculator_type = ?",'Allowance'],:joins =>:calculator
  scope :by_deduction, :conditions=>["calculators.calculator_type = ?",'Deduction'],:joins =>:calculator
  scope :by_subtotal, :conditions=>["calculators.calculator_type = ?",'Subtotal'],:joins =>:calculator

  def self.bulk_create(list,company)
    errors = []
    transaction do
      list.each_with_index do |calc,i|
        e = new(:company => company, :calculator => Calculator.find(calc.to_i), :position => i+1)
        errors << Array(e.errors) unless e.save
      end
    end
    errors.uniq
  end

end
