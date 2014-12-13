class EmployeeLeave < ActiveRecord::Base

  WORKING_HOURS = 8
   
  belongs_to :employee
  belongs_to :company
  belongs_to :salary_slip
  belongs_to :salary_sheet 
  has_many :employee_leave_types
  has_one :privilege_leave, :class_name => 'EmployeeLeaveType',:conditions => ["leave_type =?",EmployeeLeaveType::PRIVILEGE_LEAVE]
  has_one :casual_leave,:class_name => 'EmployeeLeaveType',:conditions => ["leave_type =?",EmployeeLeaveType::CASUAL_LEAVE]
  has_one :sick_leave,:class_name => 'EmployeeLeaveType',:conditions => ["leave_type =?",EmployeeLeaveType::SICK_LEAVE]
 
  accepts_nested_attributes_for :privilege_leave
  accepts_nested_attributes_for :casual_leave
  accepts_nested_attributes_for :sick_leave

  validates :company_id, :employee_id, :presence => true
  validates :present, :absent, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :allow_blank => true}

  scope :unbilled, :conditions => ["salary_slip_id is null"]
  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}
  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_month, lambda{|d|{:conditions => ["month(created_at) = ? and year(created_at) = ?",d.month,d.year]}}
  scope :for_salary_slip, lambda{|s|{:conditions => ["salary_slip_id = ?",s]}}
  scope :in_years, lambda{|yrs|{:conditions => ["year(created_at) in (?)",yrs]}}
  scope :in_months,lambda{|mnth|{:conditions => ["month(created_at) in (?)", mnth]}}
  scope :for_year, lambda{|s|{:conditions => ["year(created_at) = ?",s]}}
  scope :for_financial_year, lambda{|s|
    start_date = s.financial_year_start
    end_date = start_date.end_of_financial_year
    {:conditions => ["created_at >= ? and created_at <= ?",start_date,end_date]}
  }

  attr_accessor :company_info, :leaves_taken

  def salary_sheet
    salary_slip.try(:salary_sheet)
  end
  
  def absent_days
    absent || 0
  end

  def present_days
    present || 0
  end
  
  def days_in_month
    company.has_calculator?(LeaveAccountingCalculator) ?
      company_info.try(:month_days,salary_sheet) : Time.days_in_month(salary_sheet.run_date.month, salary_sheet.run_date.year)
  end
  
  def holidays
    # TODO : This MUST CHANGE; HOLIDAY INPUT REQUIRED
    days_in_month - present_days - absent_days - leaves_taken
  end

  def total_days
    present_days + absent_days + (privilege_leave.leaves || 0) + (sick_leave.leaves || 0) + (casual_leave.leaves || 0)
  end

  def run_date
    salary_sheet.run_date
  end
  
  def leaves_taken
    employee_leave_types.sum('leaves') || 0 if employee_leave_types
  end


  def self.earned_leaves(employee)
    return nil if !employee.company.has_calculator?(LeaveAccountingCalculator)
    elbs = EmployeeLeaveBalance.for_employee(employee).for_type(EmployeeLeaveType::PRIVILEGE_LEAVE)
    company_info = CompanyLeave.for_company(employee.company).first
    @earning ||= company_info.accrue_as_you_go? ? elbs.no_financial_year.last : elbs.for_financial_year(Date.today.year).last
  end

  def applicable_days
    EmployeeLeave.applicable_days(employee, run_date)
  end
 
  def self.applicable_days(employee, run_date)
    effective_package = employee.effective_package(run_date)
    return Time.days_in_month(run_date.month, run_date.year) if effective_package.blank?
    effective_start_date = (employee.salary_slip_charges.last.try(:charge_date) ||
        effective_package.try(:start_date) - 1)
    s_date = effective_start_date >= run_date.beginning_of_month ?
      [effective_start_date, run_date.beginning_of_month].max : [effective_start_date, run_date.beginning_of_month].min
    e_date = [effective_package.try(:end_date), run_date.end_of_month].min
    (e_date - s_date).to_f.round(2)
  end

  def total_leaves
    late_hrs = late_hours || 0
    overtime = overtime_hours || 0
    extra_work = extra_work_days || 0
    leaves = employee_leave_types.sum('unpaid')
    (leaves += absent || 0) if company.has_calculator?(LeaveAccountingCalculator)
    (leaves + (late_hrs/WORKING_HOURS) - (overtime/WORKING_HOURS) - extra_work).to_f.round(2)
  end

  def calculate!
    transaction do
      employee_leave_types.each{|leave_type| leave_type.update_leave_balance!}
    end
    # Applicable days should not come in -ve
    leave_ratio = [(applicable_days - total_leaves)/days_in_month,0].max
    if employee.resigned?
      earned_leaves = employee_leave_types.map{|a| a.earned_leaves}.sum + employee_leave_types.map{|a| a.current_balance}.sum
    end
    return [leave_ratio,total_leaves,earned_leaves || 0]
  end

  def self.leave_info(company_info,salary_slip)
    leave_info = EmployeeLeave.build_object(salary_slip.company, salary_slip.employee, salary_slip.run_date)
    leave_info.attributes = {:salary_slip => salary_slip, :company_info => company_info}
    leave_info.employee_leave_types.map{|type| type.run_date = salary_slip.run_date}
    leave_info
  end
  
  def self.determine_leave_ratio(company_info,salary_slip)
    leave_info = self.leave_info(company_info,salary_slip)
    leave_info.calculate!
  end

  def update_unpaid!
    privilege_leave.paid = 0
    privilege_leave.unpaid = absent_days + employee_leave_types.sum('leaves')
    privilege_leave.save!
  end

  def self.finalize_for_slip!(run_date,salary_slip)
    unbilled.for_month(run_date).for_employee(salary_slip.employee).each {|d| d.update_attribute(:salary_slip_id,salary_slip.id)}
  end

  def self.unfinalize_for_slip!(salary_slip)
    update_all("salary_slip_id = null",["salary_slip_id = ?",salary_slip])
  end

  def self.degrade_leave!(company_info,salary_slip)
    leave_info = self.leave_info(company_info,salary_slip)
    leave_info.employee_leave_types.each{|leave_type| leave_type.degrade_leave_balances!}
  end
 
  
  def is_destroyable?
    !is_billed?
  end

  def is_editable?
    !is_billed?
  end

  def is_billed?
    !!salary_slip_id
  end


  def self.search(company,year=Date.today.year)
    for_company(company).for_year(year).all.group_by{|leave| leave.created_at.month}
  end
       
  def self.bulk_update_or_create(attributes)
    errors = []
    attributes.each do |attr|
      transaction do
        unless attr['present'].to_i == 0
          e = find_or_initialize_by_id(attr['id'])
          errors << e.errors.to_a unless e.update_attributes(attr)
        end
      end
    end
    errors.uniq
  end

  def self.build_object(company, employee, date)
    obj = for_employee(employee).for_month(date).first
    obj = new(:employee => employee, :company => company, :present => 0,
      :absent => 0, :late_hours => 0, :overtime_hours => 0, :extra_work_days => 0, :created_at => date) unless obj
    obj.setup_leave_type
    obj
  end

  def self.detail_search(company,date=Date.today,employee=nil)
    scope = for_company(company)
    scope = scope.scoped_by_employee_id(employee) unless employee.blank?
    leaves = scope.for_month(date)
    leaves
  end
  
  def setup_leave_type
    returning(self) do |leave|
      attr = {:employee => leave.employee, :company => leave.company, :leaves => 0,:paid => 0,:unpaid => 0}
      leave.build_casual_leave(attr.merge!({:leave_type => EmployeeLeaveType::CASUAL_LEAVE}))unless leave.casual_leave
      leave.build_privilege_leave(attr.merge!({:leave_type => EmployeeLeaveType::PRIVILEGE_LEAVE}))unless leave.privilege_leave
      leave.build_sick_leave(attr.merge!({:leave_type => EmployeeLeaveType::SICK_LEAVE}))unless leave.sick_leave
    end
  end


  #set company_info accessor if there is none
  #TODO company_info attribute_accessor must be removed or set before calling a method
  def company_info
    company_info ||= CompanyLeave.for_company(company).first
  end

  def validate
    if total_days > Time.days_in_month(created_at.month)
      errors.add(:base, "Total leaves should not be greater then days in month")
    end
  end
  
end
