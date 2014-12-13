class EmployeeEsi < ActiveRecord::Base
  belongs_to :employee
  belongs_to :company
  has_many :salary_slip_charges, :as => :reference
  
  validates :esi_number, :on => :update, :if => lambda{|v|v.applicable}, :presence => true
  validates :employee_id, :company_id, :effective_date, :presence => true

  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}
  scope :for_date, lambda{|d|{:conditions => ["effective_date <= ?",d],
                                    :order => 'effective_date desc',
                                    :limit => 1}}
end
