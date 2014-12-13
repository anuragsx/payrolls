class EmployeeProfessionalTax < ActiveRecord::Base
  
  belongs_to :employee
  belongs_to :company
  has_many :salary_slip_charges, :as => :reference

  validates :employee_id, :company_id, :presence => true

  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}

end
