class EmployeeLeaveBalance < ActiveRecord::Base

  belongs_to :employee
  belongs_to :company

  validates :company_id, :employee_id, :leave_type, :presence => true
  validates :opening_balance, :current_balance, :earned_leaves, :spent_leaves, :numericality => { :only_integer => true }
  validates :financial_year, :format => { :with => /\d\d\d\d/}

  scope :for_employee, lambda{|e| {:conditions =>["employee_id = ?",e]}}
  scope :for_company, lambda{|c| {:condition => ["company_id = ?",c]}}
  scope :for_financial_year, lambda{|fy| {:conditions => ["financial_year = ?",fy]}}
  scope :no_financial_year, {:conditions => ["financial_year is null or financial_year =?", ""]}
  scope :for_type, lambda{|type| {:conditions => ["leave_type = ?",type]}}

  #TODO
  #defaults :current_balance => 0, :opening_balance => 0, :earned_leaves => 0, :spent_leaves => 0

  after_initialize :defaults

  def defaults
    self.current_balance = 0
    self.opening_balance = 0
    self.earned_leaves = 0
    self.spent_leaves = 0
  end
  
  def update_earning!(amount)
    self.earned_leaves += amount.abs
    self.save!
  end

  def update_current!(amount)
    self.current_balance += amount.abs
    self.save!
  end
  
  def update_spend!(amount)
    self.spent_leaves += amount.abs
    self.current_balance -= amount.abs
    self.save!
  end

  def degrade_earning!(amount)
    self.earned_leaves -= amount.abs
    self.save!
  end

  def degrade_current!(amount)
    self.current_balance -= amount.abs
    self.save!
  end

  def degrade_spend!(amount)
    self.spent_leaves -= amount.abs
    self.current_balance += amount.abs
    self.save!
  end
  

  def self.create_empty_leave_balance(company, employee,year = Date.today.year)
    company_info ||= CompanyLeave.for_company(company).first
    EmployeeLeaveType::LEAVE_TYPES.each do |type|
      obj = for_company(company).for_employee(employee).for_financial_year(year).for_type(type).first
      obj = (create! do |l|
          l.company = company
          l.employee = employee
          l.current_balance = company_info.send(type.downcase + "_leaves").to_i
          l.opening_balance = company_info.send(type.downcase + "_leaves").to_i
          l.earned_leaves = 0
          l.spent_leaves = 0
          l.financial_year = year
          l.leave_type = type
        end) unless obj
    end
  end
  

  def self.employee_added!(employee, accrue = nil)
    company = employee.company
    accrue ||= !!CompanyLeave.for_company(company).last.try(:accrue_as_you_go?)
    transaction do
      for_company(company).for_employee(employee).delete_all
      current_year = Date.today.year
      years = accrue ? current_year : ((employee.commencement_date.year - 1) .. (current_year + 1))
      Array(years).each do |year|
        year = nil if accrue # We have to set year to nil if as accrue
        create_empty_leave_balance(company, employee,year)
      end
    end
  end
  
  def self.settle_employee_balances!(employee, accrue = nil)
    company = employee.company
    accrue ||= !!CompanyLeave.for_company(company).last.try(:accrue_as_you_go?)
    current_year = Date.today.year
    years = accrue ? current_year : ((employee.commencement_date.year - 1) .. (current_year + 1))
    transaction do
      Array(years).each do |year|
        year = nil if accrue # We have to set year to nil if as accrue
        # Find or create leave balance
        create_empty_leave_balance(company, employee,year)
      end
      EmployeeLeaveType::LEAVE_TYPES.each do |type|
        employee_leave_bal = EmployeeLeaveBalance.for_employee(employee).for_type(type)
        as_you_go = employee_leave_bal.no_financial_year.last
        earn_now_consume_next_year = employee_leave_bal.for_financial_year(Date.today.year).last
        if as_you_go && earn_now_consume_next_year
          if accrue
            as_you_go.current_balance = earn_now_consume_next_year.current_balance
            as_you_go.earned_leaves = earn_now_consume_next_year.earned_leaves
            as_you_go.spent_leaves = earn_now_consume_next_year.spent_leaves
            as_you_go.save!
          else
            earn_now_consume_next_year.current_balance = as_you_go.current_balance
            earn_now_consume_next_year.earned_leaves = as_you_go.earned_leaves
            earn_now_consume_next_year.spent_leaves = as_you_go.spent_leaves
            earn_now_consume_next_year.save!
          end
        end
      end
    end
  end

end