class DepartmentHoliday < ActiveRecord::Base
  belongs_to :department
  belongs_to :company
  belongs_to :holiday

  validates_presence_of :department_id, :company_id, :holiday_id 

end
