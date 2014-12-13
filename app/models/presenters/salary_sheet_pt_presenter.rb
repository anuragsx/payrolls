class SalarySheetPtPresenter

  def initialize(company,salary_sheet)
    @@professional_tax_head ||= SalaryHead.code_for_professional_tax
    @company = company
    @salary_sheet = salary_sheet
    @total_employees = []
    @grand_total_pt = 0.0
    @grand_base_charge = 0
    @dept_detail ={}
    @salary_sheet.salary_slip_charges.under_head(@@professional_tax_head).group_by{|x| x.employee.department}.each do |department,charges|
      @dept_detail[department] ={:name => department.name,
                                 :slips => [],
                                 :pt_total => 0.0,
                                 :base_total => 0.0
                                }
      charges.each do |charge|
        @slip_presenter = SlipPtPresenter.new(charge.salary_slip)
        @dept_detail[department][:slips] << @slip_presenter
        @dept_detail[department][:pt_total] += @slip_presenter.tax_deduction
        @dept_detail[department][:base_total] += @slip_presenter.base_charge
        @total_employees << @slip_presenter.employee
      end
      @grand_total_pt += @dept_detail[department][:pt_total]
      @grand_base_charge += @dept_detail[department][:base_total]
    end
  end

  def salary_sheet
    @salary_sheet
  end
  
  def total_employees
    @total_employees.uniq.size
  end

  def departments
    @dept_detail.values
  end

  def month_date
    @salary_sheet.formatted_run_date
  end
  
  def grand_total_pt
    @grand_total_pt.abs
  end
  
  def grand_total_base_charge
    @grand_base_charge
  end
  
end
