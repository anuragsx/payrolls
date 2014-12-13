class CompanyLeave < ActiveRecord::Base
  attr_accessible :company
  LEAVE_ACCRUAL = [["Earn now consume next year",1],["Earn and spend as you go",2]]
  MONTH_DAY_CALC = [["Take total days of month (Default)",3],["Input will be given with Salary Sheet",1],["Fix for all Salary Sheet",2]]
  EARN_NOW_CONSUME_NEXT_YEAR = 1
  AS_YOU_GO = 2

  belongs_to :company

  validates :company_id, :month_day_calculation, :leave_accrual, :rate_of_leave, :presence => true
  validates :leave_accrual, :rate_of_leave, :month_length, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :month_day_calculation, :numericality => { :only_integer => true }


  validates :leave_accrual, :inclusion => {:in => 1..2}
  validates :month_day_calculation, :inclusion => {:in => 1..3}

  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}
  
  after_create :create_opening_balance_on_all_employees
  after_update :plan_change_settlement
  
  #defaults :leave_accrual => 1, :rate_of_leave => 20, :month_day_calculation => 3, :month_length => 30,
    #:casual_leaves => 12 ,:sick_leaves => 12

  after_initialize :defaults

  def defaults
    self.leave_accrual = 1
    self.rate_of_leave = 20
    self.month_day_calculation = 3
    self.month_length = 30
    self.casual_leaves = 12
    self.sick_leaves = 12
  end

  def accrue_as_you_go?
    leave_accrual == AS_YOU_GO
  end

  def month_days(salary_sheet)
    case month_day_calculation
    when 1
      salary_sheet.try(:month_length) || salary_sheet.total_days_in_month
    when 2
      month_length
    when 3
      salary_sheet.total_days_in_month
    else
      salary_sheet.total_days_in_month
    end
  end

  def default_length(date)
    case month_day_calculation
    when 2
      month_length
    when 1,3
      Time.days_in_month(date.month,date.year)
    end
  end

  def month_length_desc
    MONTH_DAY_CALC.detect{|d|d[1]==month_day_calculation}.try(:first)
  end

  def create_opening_balance_on_all_employees
    transaction do
      company.active_employees.each do |e|
        EmployeeLeaveBalance.employee_added!(e,accrue_as_you_go?)
      end
    end
  end

  def plan_change_settlement
    transaction do
      company.active_employees.each do |e|
        EmployeeLeaveBalance.settle_employee_balances!(e,accrue_as_you_go?)
      end
    end
  end

  def carry_forward_leave_balances!(from_year,to_year)  
    unless accrue_as_you_go?
      while from_year < to_year do
        transaction do
          company.employees.each do |employee|
            next_year = from_year.to_i + 1
            type = EmployeeLeaveType::PRIVILEGE_LEAVE
            prev = EmployeeLeaveBalance.for_employee(employee).for_financial_year(from_year).for_type(type).last
            current = EmployeeLeaveBalance.for_employee(employee).for_financial_year(next_year).for_type(type).last
            attrs = {:company => company, :employee => employee,
              :leave_type => type, :financial_year => next_year ,
              :current_balance => (prev.try(:current_balance) + prev.try(:earned_leaves) || 0),
              :opening_balance => (prev.try(:current_balance) + prev.try(:earned_leaves) || 0),
              :earned_leaves => current.try(:earned_leaves) || 0,
              :spent_leaves => current.spent_leaves || 0
            }
            !current.blank? ? current.update_attributes(attrs) :  EmployeeLeaveBalance.create(attrs)
          end
        end
        from_year += 1
      end
    end
  end   

  def privilege_leaves
    0
  end

end
