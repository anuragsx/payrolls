class SalarySheetIncomeTaxPresenter

  attr_reader :salary_sheet

  def initialize(company, salary_sheet)
    @@income_tax_head ||= SalaryHead.code_for_tds
    @company = company
    @salary_sheet = salary_sheet    
    @total_tds_charges = @salary_sheet.salary_slip_charges.under_head(@@income_tax_head)
  end

  def init_for_slip
    @departments = {}
    @salary_sheet.slips_group_by_department.each do |dept,salary_slips|
      @departments[dept] = {:name => dept.try(:name),
             :total_tax => 0, :total_edu_cess => 0,
             :total_tds => 0,
             :slips => []
      }
      salary_slips.each do |slip|
        tax = slip_tax(slip).abs
        if tax > 0
          edu_cess = calc_edu(tax)
          @departments[dept][:slips] << {:employee => slip.employee,
                :name => slip.employee.try(:name),
                :tax => (tax - edu_cess), :edu_cess => edu_cess, :tds => tax
          }
          @departments[dept][:total_tax] += (tax - edu_cess)
          @departments[dept][:total_edu_cess] += edu_cess
          @departments[dept][:total_tds] += tax
        end
      end
    end
  end

  def total_employees
    @total_tds_charges.size
  end

  def total_tds
    @total_tds_charges.sum(:amount).abs
  end

  def total_edu_cess
    calc_edu(total_tds)
  end

  def total_tax
    total_tds - total_edu_cess
  end

  def month_date
    @salary_sheet.formatted_run_date
  end

  def departments
    init_for_slip()
    @departments.values
  end

  private

  def slip_tax(slip)
    slip.salary_slip_charges.under_head(SalaryHead.code_for_tds).first.try(:amount) || 0
  end

  def calc_edu(tax)
    (tax * (EDUCATION_CESS/ (1 + EDUCATION_CESS))).round
  end

end