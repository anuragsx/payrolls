class CompanyPf < ActiveRecord::Base
  attr_accessible :company
  belongs_to :company
  belongs_to :pf_type
  has_many :employee_pensions, :dependent => :destroy
  has_many :salary_slip_charges, :as => :reference

  validates :company_id, :pf_type_id, :pf_number, :presence => true
  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}

  #defaults :pf_type => PfType.find_by_type("PrivatePension"), :pf_number => "RJ/0123"

  after_initialize :defaults

  def defaults
    PfType.find_by_type("PrivatePension")
    self.pf_number = "RJ/0123"
  end

  attr_accessor :effective_base

  def activate_on_all_employees
    company.employees.all.each do |e|
      employee_pensions.create(:employee => e, :company => company, :total_pf_contribution => 0)
    end
  end

  def pf_name
    self.pf_type.try(:name)
  end
  
  def self.pf_number(company)
    for_company(company).last.try(:pf_number)
  end
    
  def self.statutory_rate(company)
    for_company(company).last.try(:pf_type).try(:effective_employee_percent)
  end

  def company_charges
    # Find Employer Contributions
    charges = []
    pf_type.employer_charges_for_sheet(effective_base).each do |c|
      c[:reference] = self
      c[:base_charge] = effective_base
      c[:description] = "Employer Contribution on effective base of #{effective_base.round(2)} [#{pf_type.name}]"
      charges << c
    end
    charges
  end
end
