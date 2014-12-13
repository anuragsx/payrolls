class MonthlyAttendancePresenter
  
  def initialize(company,date)
    @date =  date
    @attendances = Attendance.for_company(company).for_month(@date)
    @detail ={}
    @attendances.group_by{|x|x.employee}.each do |emp,attendances|
      @detail[emp] ={}
      attendances.each{|att| @detail[emp][att.attendance_date.to_s(:date_month_and_year)] = att.attendance_type}
    end
  end
  
  def type(emp,date)
    att_type = @detail[emp][date.to_s(:date_month_and_year)]
    unless att_type.nil?
      case att_type[:type].downcase.to_sym
      when :present; return "<span class='present'>*</span>"
      when :absent; return "X"
      when :casual; return "cl"
      when :privilege; return "pl"
      when :sick; return "sl"
      end
    end
  end

  def employees
    @detail.keys.sort_by{|x|x.name}
  end
  
  def dates
    @dates = @date.month_dates
  end   

end