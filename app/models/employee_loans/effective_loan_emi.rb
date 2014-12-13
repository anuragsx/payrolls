class EffectiveLoanEmi < ActiveRecord::Base
  
  belongs_to :employee
  belongs_to :employee_loan

  validates :amount, :presence => true
  validates :employee_loan_id, :on => :update, :presence => true
  validates :amount, :greater_than => 0, :numericality => { :only_integer => true }
  before_destroy :is_destroyable?

  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_date, lambda{|date| {:conditions => ["created_at < ?",date], :order => "created_at DESC", :limit => 1}}

  def validate
    errors.add(:amount, "Must be less than Loan Amount") if amount && employee_loan && employee_loan.loan_amount < amount
  end

  def is_editable?
    !billed_for?(created_at.to_date)
  end

  def is_destroyable?
    !billed_for?(created_at.to_date)
  end
  
  private
  #Returns true if salary sheet exist for given date else false
  def billed_for?(date)
    !employee_loan.salary_slip_charges.for_month(date).blank?
  end

end