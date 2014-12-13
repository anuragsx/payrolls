class EmployeePackageHead < ActiveRecord::Base

  belongs_to :employee
  belongs_to :company
  belongs_to :employee_package
  belongs_to :salary_head
  has_many :salary_slip_charges, :as => :reference
  
  validates :amount, :employee, :company, :presence => true
  validates :amount, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  scope :for_company, lambda{|e|{:conditions => ["company_id = ?",e]}}
  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_head, lambda{|h|{:conditions => ["salary_head_id = ?",h]}}
  scope :for_package, lambda{|h|{:conditions => ["employee_package_id = ?",h]}}
  scope :for_code, lambda{|c|{:conditions => ["salary_head.code = ?",c], :joins => [:salary_head]}}

  before_save :set_leave_dependent

  def set_leave_dependent
    self.leave_dependent = true unless self.leave_dependent
  end
end