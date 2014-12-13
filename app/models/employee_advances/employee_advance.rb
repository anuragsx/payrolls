class EmployeeAdvance < ActiveRecord::Base
  belongs_to :employee
  belongs_to :company
  belongs_to :salary_slip
  has_many :salary_slip_charges, :as => :reference

  scope :unbilled, :conditions => "salary_slip_id is null"
  scope :for_company, lambda{|c|{:conditions => ["employee_advances.company_id = ?",c]}}
  scope :in_year, lambda{|year|{:conditions => ["year(created_at) = ?",year]}}
  scope :for_date, lambda{|date|{:conditions => ["created_at <= ?",date]}}
  scope :for_employee, lambda{|e| {:conditions => ["employee_id = ?",e]}}
  scope :find_by_years  , lambda{|ys| { :conditions => ["year(created_at) in (?)",ys] } }
  scope :find_by_months  , lambda{|mnth| { :conditions => ["month(created_at) in (?)", mnth] } }
  scope :in_fy, lambda{|d|
    start_date = Date.financial_year_start(d)
    end_date = start_date.end_of_financial_year
    {:conditions => ["created_at >= ? and created_at <= ?",start_date,end_date]}
  }
  
  validates :employee_id, :company_id, :amount, :created_at, :presence => true
  validates :amount, :greater_than => 0, :numericality => { :only_integer => true }

  def validate_on_create
    if !created_at.blank? && !self.company.salary_sheets.salary_sheet_for(created_at).blank?
      errors.add_to_base("Salary Sheet for #{self.created_at.to_s(:month_and_year)} has been finalized")
    end
  end

  def validate_on_update
    errors.add_to_base("This advance has been billed") if amount_changed? && billed?
  end

  def self.finalize_for_slip!(run_date,salary_slip, employee)
    unbilled.for_date(run_date).for_employee(employee).each {|d| d.update_attribute(:salary_slip_id,salary_slip.id)}
  end

  def self.unfinalize_for_slip!(salary_slip)
    update_all("salary_slip_id = null",["salary_slip_id = ?",salary_slip.id])
  end

  def billed?
    !salary_slip_id.blank?
  end

  def self.search(company,employee,year=Date.today.year)
    scope = for_company(company)
    scope = scope.scoped_by_employee_id(employee) unless employee.blank?   
    scope.in_fy(year).all.group_by{|m|m.created_at.month}
  end


  def self.initialize_by(company,employee,date)
    for_company(company).for_employee(employee).for_date(date).first or
      new(:company => company, :employee => employee, :created_at => date)
  end

  def self.create_multi(attributes,company,date=Date.today)
    errors = []
    attributes.reject{|a|a['amount'].blank? or a['amount'].to_i == 0}.each do |attr|
      transaction do
        e = self.new(attr)
        e.created_at = date
        e.company = company
        unless e.save
          errors << e.errors.to_a
        end
      end
    end
    errors.uniq
  end

end