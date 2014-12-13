class CompanyEsi < ActiveRecord::Base
  attr_accessible :company
  belongs_to :company
  belongs_to :esi_type

  validates :company_id, :esi_type_id, :esi_number, :presence => true

  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}

  after_initialize :defaults

  def defaults
    self.esi_type = EsiType.find_by_name("Shops Act")
    self.esi_number = "15/17494"
  end

  #defaults :esi_type => EsiType.find_by_name("Shops Act"), :esi_number => "15/17494"
  #after_create :activate_on_all_employees
  
  attr_accessor :gross, :effective_base

  def create_for_employee(employee,effective_date,esi_number=nil)
    applicable = employee.current_package.gross <= esi_type.basic_threshold
    EmployeeEsi.create!(:employee => employee,
                        :company => company,
                        :esi_number => esi_number,
                        :applicable => applicable,
                        :effective_date => effective_date)
  end

  def esi_name
    self.esi_type.try(:name)
  end

  def activate_on_all_employees
    existing_employees = EmployeeEsi.for_company(company).all.map(&:employee)
    (company.employees.all - existing_employees).each{|e|create_for_employee(e,e.commencement_date)}
  end

  def eligible?(gross)
    gross <= esi_type.basic_threshold
  end

  def employer_contrib
    (effective_base * esi_type.employer_contrib_percent / 100.0).ceil
  end

  def employee_contrib
    -1.0*(gross * esi_type.employee_contrib_percent / 100.0).ceil
  end

  def employee_description
    "Employee ESI Contribution at #{esi_type.employee_contrib_percent}% on #{gross.to_f.round(2)}"
  end

  def employer_description
    "Employer ESI Contribution at #{esi_type.employer_contrib_percent}% on #{effective_base.to_f.round(2)}"
  end

  def create_employee(employee,date = Date.today)
    EmployeeEsi.create(:employee=>employee,:company=>employee.company,
                       :applicable=>true,:effective_date=>date)
  end

  def suspend_employee(employee,date = Date.today)
    emp_esi = EmployeeEsi.for_employee(employee).for_date(date).last
    emp_esi && emp_esi.update_attribute(:applicable,false)
  end
  
end
