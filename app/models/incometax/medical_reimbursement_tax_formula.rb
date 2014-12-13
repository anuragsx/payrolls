class MedicalReimbursementTaxFormula < TaxFormula

  MEDICAL_THRESHOLD = 1250
  
  def initialize(amount = 0,threshold = MEDICAL_THRESHOLD)
    @amount = amount
    @threshold = threshold
  end

  def employee_tds
    EmployeeTaxDetail.for_employee(employee).last
  end

  def eligible_for_employee?
    !!employee_tds
  end

  def billed_charges
    salary_head.salary_slip_charges.for_employee(employee).upto_date_within_fy(run_date.year, run_date)
  end

  def allready_billed
    billed_charges.sum(:amount) || 0
  end

  def slip_count
    billed_charges.group_by(&:salary_slip).size + 1
  end

  def old_taxables
    # Calculate the old taxable amount here
    billed_charges.sum(:taxable_amount) || 0
  end

  def calculate
    if eligible_for_employee?
      self.threshold = MEDICAL_THRESHOLD * slip_count
      self.amount += allready_billed - old_taxables
      return amount - exemption
    end
    amount
  end

  def exemption
    [amount, threshold].min
  end
end