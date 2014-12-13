class EmployeePension < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  EXIT_REASONS = ["Retiring","Leaving Country for Permanent Settlement Abroad",
                  "Retrenchment","Permanent & Total Disablement due to Employment Injury",
                  "Discharged", "Resigning from or leaving service", "Taking up employment elsewhere",
                  "Dead", "attained age of 58 years"]

  belongs_to :employee
  belongs_to :company
  belongs_to :company_pf
  has_many :salary_slip_charges, :as => :reference

  validates :company_pf, :precense => true
  validates :exit_reason, :inclusion => { :in => EXIT_REASONS, :allow_blank => true }

  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}
  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :eligible, lambda{|d|{:conditions => ["(deleted_at is null or deleted_at = '')
                                                      or (month(deleted_at) = ? and year(deleted_at) = ?)",d.month,d.year]}}
  scope :for_date, lambda{|d|{:conditions => ["created_at <= ?",d],
                                    :order => 'created_at desc',
                                    :limit => 1}}
  scope :joined_in_month, lambda{|d|{:conditions => ["month(created_at) = ? and year(created_at) = ?",d.month,d.year]}}
  scope :left_in_month, lambda{|d|{:conditions => ["month(deleted_at) = ? and year(deleted_at) = ?",d.month,d.year]}}

  attr_accessor :basic, :da, :employee_contribution, :dr

  before_save :fix_date
  
  def pf_type
    company_pf.pf_type
  end
  memoize :pf_type
  
  def statutory_charges
    effective_base = pf_type.effective_base_for_employee(basic,da, dr)
    effective_base_for_company = pf_type.effective_base_for_company(basic,da,dr)
    # Find Employee Contribution
    self.employee_contribution = pf_type.employee_contrib(effective_base)
    charges = [{:amount => -1 * self.employee_contribution.abs,
                :employee => employee,
                :reference => self,
                :base_charge => effective_base,
                :description => "Employee PF Contribution on effective base of #{effective_base.to_f.round(2)} at #{pf_type.effective_employee_percent} [#{pf_type.name}]",
                :salary_head => SalaryHead.code_for_employee_pf}]
    vpf = voluntary_charges
    vpf_amount = 0
    if vpf
      charges << vpf
      vpf_amount = match_company_vpf? ? vpf[:amount].abs : 0
    end
    # Find Employer Contributions
    pf_type.employer_charges(effective_base_for_company,vpf_amount).each do |c|
      c[:reference] = company_pf
      c[:base_charge] = effective_base_for_company
      c[:description] = "Employer Contribution on effective base of #{effective_base_for_company.to_f.round(2)} [#{pf_type.name}]"
      charges << c
    end
    charges
  end

  def voluntary_charges
    if !vpf_amount.blank? && vpf_amount > 0
      amount = vpf_amount
      description = "Voluntary Pension Contribution of #{vpf_amount}"
      base_charge = amount
    elsif !vpf_percent.blank? && vpf_percent > 0
     amount = employee_contribution.abs * vpf_percent / 100.0
     description = "Voluntary Pension Contribution at #{vpf_percent}% of #{employee_contribution.abs.to_f.round(2)}"
     base_charge = employee_contribution.abs.to_f.round(2)
    elsif !total_pf_contribution.blank? && total_pf_contribution > 0
     amount = [total_pf_contribution-employee_contribution.abs,0].max
     description = "Voluntary Pension Contribution of #{total_pf_contribution} including statutory #{employee_contribution.abs.to_f.round(2)}"
     base_charge = total_pf_contribution
    else
      amount = 0
    end
    return {:amount => -1.0 * amount.abs,
            :salary_head => SalaryHead.code_for_employee_vpf,
            :reference => self,
            :base_charge => base_charge,
            :description => description,
            :employee => employee} if amount.abs > 0
  end

  def created_at_before_type_cast
    (read_attribute(:created_at)).to_s(:date_month_and_year) if read_attribute(:created_at)
  end

  def deleted_at_before_type_cast
    (read_attribute(:deleted_at)).to_s(:date_month_and_year) if read_attribute(:deleted_at)
  end

  def deleted?
    !deleted_at.blank?
  end

  def self.epf_for_employee(employee)
    for_employee(employee).first.try(:epf_number)
  end

  def fix_date
    self.created_at = self.created_at.try(:to_datetime)
  end
end
