class AttendancePresenter
 
  def initialize(company,employee,this_year)
    @details ={}
    @attendances = Attendance.for_company(company).for_employee(employee).for_year(this_year)
    @attendances.group_by{|a|a.attendance_date.month}.each do |month,attendances|
      @details[month] ={:present => attendances.sum{|a|a.attendance_type.is_present? ? 1 : 0},
        :absent => attendances.sum{|a| a.attendance_type.is_absent? ? 1 : 0},
        :leaves => attendances.sum{|a| !a.attendance_type.is_present? && !a.attendance_type.is_absent? ? 1 : 0}
      }
    end
  end  
    
  def total_persent(month)
    @details[month][:present] unless @details[month].blank?
  end
  
  def total_absent(month)
    @details[month][:absent] unless @details[month].blank?
  end
  
  def total_leaves(month)
    @details[month][:leaves] unless @details[month].blank?
  end
  
end
