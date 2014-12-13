class AddCloumnToCompanyLeave < ActiveRecord::Migration
  def self.up
    add_column :company_leaves, :casual_leaves, :float
    add_column :company_leaves, :sick_leaves, :float
    add_column :attendance_types, :type, :string
    AttendanceType.reset_column_information
    EmployeeLeaveBalance.all.each do |ty|
      if ty.company &&  ty.employee
        ty.leave_type = EmployeeLeaveType::PRIVILEGE_LEAVE
        ty.save!
        EmployeeLeaveBalance.create_empty_leave_balance(ty.company, ty.employee,ty.financial_year)
      end
    end
    EmployeeLeave.all.each do |el|
      if el.company &&  el.employee
        el.setup_leave_type
        el.privilege_leave.attributes = { :paid => el.paid, :unpaid => el.unpaid,
                                          :earned => el.earned, :spent => el.spent }
        el.save!
      end
    end
    Company.all.map{|c| CompanyLeave.find_or_create_by_company_id(c.id)}
    AttendanceType.find_or_create_by_name("Present").update_attribute('type',AttendanceType::PRESENT)
    AttendanceType.find_or_create_by_name("Absent without Leave").update_attribute('type', AttendanceType::ABSENT)
    AttendanceType.find_or_create_by_name("Casual Leave").update_attribute('type', AttendanceType::CASUAL_LEAVE)
    AttendanceType.find_or_create_by_name("Privilege Leave").update_attribute('type', AttendanceType::PRIVILEGE_LEAVE)
    AttendanceType.find_or_create_by_name("Sick leave").update_attribute('type', AttendanceType::SICK_LEAVE)
    AttendanceType.find_by_name("Approved Absence").try(:destroy)
  end

  def self.down
    remove_column :company_leaves, :casual_leaves
    remove_column :company_leaves, :sick_leaves
    remove_column :attendance_types, :type
  end
end
