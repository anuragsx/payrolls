class EmployeeTax < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :employee
  belongs_to :company
  #belongs_to :salary_slip
  has_many :salary_slip_charges, :as => :reference

  validates :amount, :employee_id, :company_id, :presence => true
  validates :amount, :greater_than_or_equal_to => 0, :numericality => { :only_integer => true }

  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :after_date, lambda{|d|{:conditions => ["created_at < ?",d]}}

end
