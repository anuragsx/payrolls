class Attendance < ActiveRecord::Base
  belongs_to :employee
  belongs_to :company
  belongs_to :approval_status
  belongs_to :attendance_type

  validates_presence_of :employee, :company, :attendance_type, :attendance_date
  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}
  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_month, lambda{|d|{:conditions => ["month(attendance_date) = ? and year(attendance_date) = ?",d.month,d.year]}}
  scope :for_salary_slip, lambda{|s|{:conditions => ["salary_slip_id = ?",s]}}
  scope :in_years, lambda{|yrs|{:conditions => ["year(attendance_date) in (?)",yrs]}}
  scope :in_months,lambda{|mnth|{:conditions => ["month(attendance_date) in (?)", mnth]}}
  scope :for_year, lambda{|s|{:conditions => ["year(attendance_date) = ?",s]}}
  scope :for_date, lambda{|d|{:conditions => ["attendance_date = ? and month(attendance_date) = ? and year(attendance_date) = ?",d,d.month,d.year]}}
  scope :for_financial_year, lambda{|s|
    start_date = s.financial_year_start
    end_date = start_date.end_of_financial_year
    {:conditions => ["attendance_date >= ? and attendance_date <= ?",start_date,end_date]}
  }
  before_save :update_employee_leave
    
  def self.build_object(company, employee, date)
    obj = for_employee(employee).for_date(date).first
    obj = new(:employee => employee, :company => company,:attendance_date => date) unless obj
    obj
  end
  
  def self.bulk_update_or_create(attributes,company)
    errors = []
    attributes.each do |attr|
      attr.merge!({:company => company})
      transaction do
        unless attr[:attendance_type_id].blank?
          e = find_or_initialize_by_id(attr['id'])
          errors << e.errors.to_a unless e.update_attributes(attr)
        end
      end
    end
    errors.uniq
  end
    

  def update_employee_leave
    return unless valid?
    begin
      obj = EmployeeLeave.build_object(self.company,self.employee,self.attendance_date)
      att_type = self.attendance_type
      elt = obj.employee_leave_types.for_type(att_type[:type].to_s).last if obj.save!
      if elt
        elt.leaves +=1
        elt.save!
      elsif elt.blank? && att_type.is_present?
        obj.present += 1
      elsif elt.blank? && att_type.is_absent?
        obj.absent += 1
      end
      update_attendance(obj) unless self.new_record?
      obj.save!
    rescue Exception => e
      errors.add_to_base(e.message)
      return false
    end
  end
  
  def update_attendance(obj)
    att_type =  AttendanceType.find(self.attendance_type_id_was)
    elt = obj.employee_leave_types.for_type(att_type[:type].to_s).last
    if elt
      elt.leaves -=1
      elt.save!
    elsif elt.blank? && att_type.is_present?
      obj.present -= 1
    elsif elt.blank? && att_type.is_absent?
      obj.absent -= 1
    end
  end
 
   
end
