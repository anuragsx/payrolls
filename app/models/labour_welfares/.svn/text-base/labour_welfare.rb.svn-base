class LabourWelfare < ActiveRecord::Base

  has_many :labour_welfare_slabs

  validates_presence_of :zone,:submissions_count, :paid_to
  validates_numericality_of :submissions_count, :greater_than => 0

  def calculate_charge(salary_slip)
    basic = salary_slip.charge_for(SalaryHead.code_for_basic)
    slab = labour_welfare_slabs.select{|lws| (lws.salary_min <= basic && lws.salary_max >= basic)}.first
    {:employee_contri => slab.employee_contribution, :employer_contri => slab.employer_contribution}
  end
end