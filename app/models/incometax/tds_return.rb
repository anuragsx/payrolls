class TdsReturn < ActiveRecord::Base
  belongs_to :company
  has_many   :employee_tds_returns
  has_many   :employees, :through => :employee_tds_returns


  scope :for_company, lambda{|c|{:conditions => ["company_id = ?", c]}}
  scope :in_fy, lambda{|fy|{:conditions => ["year(start_date) = ?",fy]}}
  scope :for_date, lambda{|date|{:conditions => ["start_date = ?",date]}}


  accepts_nested_attributes_for :employee_tds_returns,:reject_if => proc {| attrs| attrs["is_included"] == '0' }
  validates :start_date, :company_id, :presence => true

  def self.build_object(company,date)
    obj = for_company(company).in_fy(date.year).for_date(date).first
    obj = new(:company => company,:start_date => date) unless obj
    company.employees.each do |emp|
      emp_tds = obj.employee_tds_returns.find_by_company_id_and_employee_id(company,emp)
      if (!emp_tds)
        e = EmployeeTdsReturn.new(:employee => emp, :company => company, :start_date => obj.start_date, :end_date => obj.end_date)
        if e.tds_deposited > 0
          obj.employee_tds_returns << e
        end
      end
    end
    obj
  end

  def end_date
    start_date + 3.months - 1.day
  end

  def total_deducted_from_employees
    employee_tds_returns.to_a.sum{|x|x.tds_deposited}
  end

  def quarter
    start_date.financial_quarter
  end

  def self.for_financial_year(company,date)
    q_years =ActiveSupport::OrderedHash.new
    quarters(date).each do |q|
      q_years[q.financial_quarter] = for_company(company).scoped_by_start_date(q).first  || new(:start_date => q,:company => company)
    end
    q_years
  end

  private

  def self.quarters(date)
    (1..4).map{|x| date.send("beginning_of_financial_q#{x}")}
  end

end
