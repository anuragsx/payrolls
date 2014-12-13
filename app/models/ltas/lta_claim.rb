class LtaClaim < ActiveRecord::Base
  belongs_to :company
  belongs_to :employee
  belongs_to :salary_slip
  belongs_to :lta


  has_many :salary_slip_charges, :as => :reference

  validates :company_id, :employee_id, :amount, :claim_year,:block,:lta_id, :precense => true
  validates :amount, :numericality => { :only_integer => true }
  validates :lta_id, :uniqueness => true
  validates :employee_id, :scope => :claim_year, :uniqueness => true


  scope :for_employee, lambda{|e|{:conditions => ["employee_id = ?",e]}}
  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}
  scope :unbilled, :conditions => "salary_slip_id is null"
  scope :billed, :conditions => "salary_slip_id is not null"
  scope :for_slip, lambda{|s|{:conditions => ["salary_slip_id = ?",s]}}
  scope :for_lta, lambda{|l|{:conditions => ["lta_id = ?",l]}}
  scope :for_date, lambda{|date|{:conditions => ["created_at <= ?",date]}}
  scope :in_fy, lambda{|d|
    start_date = Date.financial_year_start(d)
    end_date = start_date.end_of_financial_year
    {:conditions => ["created_at >= ? and created_at <= ?",start_date,end_date]}
  }
  validate :check_claim_amount, :max_2_in_block
  
  def self.finalize_for_slip!(run_date,salary_slip, employee)
    unbilled.for_date(run_date).for_employee(employee).each{|d|d.update_attribute(:salary_slip_id,salary_slip.id)}
  end

  def self.unfinalize_for_slip!(salary_slip)
    update_all("salary_slip_id = null",["salary_slip_id = ?",salary_slip.id])
  end
   
  def self.effective(employee,date)
    self.for_employee(employee).in_fy(date.financial_year)
  end
   
  def self.total_billed(employee,date)
    effective(employee,date).billed.sum('amount') || 0
  end
  
  def self.total_unbilled(employee,date)
    effective(employee,date).unbilled.sum('amount') || 0
  end
  
  def is_billed?
    !!salary_slip_id
  end

  private
  
  def check_claim_amount
    unless amount.blank? || self.lta.nil?
      unless (amount <= self.lta.amount)
        errors.add_to_base("Claim amount is not eligible.")
        false
      else
        true
      end
    end
  end

  def max_2_in_block
    unless created_at.blank?
      total_ltas = LtaClaim.scoped_by_block(created_at.to_date.exempt_block).count
      (total_ltas += 1)if self.new_record?
      if (total_ltas > 2)
        errors.add_to_base("Sorry! You cann't exempt more then 2 journey in one block.")
        false
      else
        true
      end
    end
  end


end
