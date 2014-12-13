class Lta < ActiveRecord::Base
  belongs_to :company
  belongs_to :employee
  belongs_to :salary_slip
  has_one :lta_claim
  has_many :salary_slip_charges, :as => :reference


  validates :company_id, :employee_id, :amount, :description, :presence => true
  validates :amount, :numericality => { :only_integer => true }


  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}
  scope :for_financial_year, lambda{|fy|{:conditions => ["year(created_at) = ?",fy]}}
  scope :for_date, lambda{|date|{:conditions => ["created_at <= ?",date]}}
  scope :unbilled, :conditions => "salary_slip_id is null"
  scope :billed, :conditions => "salary_slip_id is not null"
  scope :for_slip, lambda{|s|{:conditions => ["salary_slip_id = ?",s]}}
  scope :current_block, {:conditions => ["block = ?",Date.today.exempt_block]}

  
  def self.finalize_for_slip!(run_date,salary_slip, employee)
    unbilled.for_date(run_date).for_employee(employee).each {|d| d.update_attribute(:salary_slip_id,salary_slip.id)}
  end

  def self.unfinalize_for_slip!(salary_slip)
    update_all("salary_slip_id = null",["salary_slip_id = ?",salary_slip.id])
  end
  
  def self.not_claims(employee,obj)
    ltas = for_employee(employee).current_block.delete_if{|l| !l.lta_claim.nil?} || []
    ltas << obj if obj
    ltas 
  end
  
  def name
    description + " Rs." + amount.to_s
  end
  
  def is_billed?
    !!salary_slip_id
  end
  
end
