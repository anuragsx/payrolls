class EmployeeInsurancePolicy < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  belongs_to :company
  belongs_to :employee


  has_many :salary_slip_charges, :as => :reference
  
  validates :employee_id, :company_id, :monthly_premium, :name, :expiry_date, :presence => true
  validates :monthly_premium, :greater_than => 0
  validate_on_update :cannot_backdate_expiry

  before_destroy :destroyable?
  
  scope :active_on, lambda{|date|{:conditions => ["(expiry_date is null or expiry_date > ?) and created_at < ?",date,date]}}
  scope :for_employee, lambda{|emp|{:conditions => ["employee_id = ?",emp]}}
  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}

  def description
    s = "Premium for #{name}"
    s += " expiring at #{expiry_date.to_s(:rfc822)}" if expiry_date
    s
  end

  def expired?(run_date)
    !expiry_date || expiry_date < run_date
  end

  def total_premium_paid
    salary_slip_charges.billed.sum(:amount).abs.round(2)
  end

  def destroyable?
    salary_slip_charges.billed.empty?
  end

  def self.bulk_update_or_create(company,attributes)
    errors = []
    attributes.each do |attr|
      transaction do
        unless attr['name'].blank?
          e = find_or_initialize_by_id(attr['id'])
          e.company = company
          errors << e.errors.to_a unless e.update_attributes(attr)
        end
      end
    end
    errors.uniq
  end

  private

  def cannot_backdate_expiry
    if expiry_date_changed? and !!expiry_date_was and expiry_date_was > expiry_date and !salary_slip_charges.billed.after_date(expiry_date_was).blank?
      errors.add_to_base("Billed Charges exist after this expiry date")
      return false
    end
  end
end
