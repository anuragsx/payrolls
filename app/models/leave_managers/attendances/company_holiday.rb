class CompanyHoliday < ActiveRecord::Base
  
  belongs_to :company
  belongs_to :holiday
  validates_presence_of :company_id, :holiday_id

end
