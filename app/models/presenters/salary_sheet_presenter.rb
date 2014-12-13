class SalarySheetPresenter

  attr_reader :salary_sheet,:company
  
  def initialize(company,salary_sheet)
    @company = company
    @salary_sheet = salary_sheet
    @dept_details = {}
    @grand_total_basic = 0
    @grand_total_leaves = 0
    @grand_total_deduction = 0
    @grand_total_gross = 0
    @grand_total_net = 0
    @salary_sheet.slips_group_by_department.each do |department,salary_slips|
      @dept_details[department] = {:name => department.try(:name),
        :slips => salary_slips,
        :total_basic => 0,
        :total_leaves => 0,
        :total_deduction => 0,
        :total_gross => 0,
        :total_net => 0,
        :slip => {}
      }
      salary_slips.each do |s|
        @slip_presenter = SalarySlipPresenter.new(s)
        @dept_details[department][s]=  @slip_presenter
        @dept_details[department][:total_leaves]+= @slip_presenter.total_leaves
        @dept_details[department][:total_deduction]+= @slip_presenter.total_deduction
        @dept_details[department][:total_gross]+= @slip_presenter.gross
        @dept_details[department][:total_net]+= @slip_presenter.net
        @dept_details[department][:total_basic]+= @slip_presenter.basic
      end
      @grand_total_leaves+= @dept_details[department][:total_leaves]
      @grand_total_deduction+= @dept_details[department][:total_deduction]
      @grand_total_gross+= @dept_details[department][:total_gross]
      @grand_total_net+= @dept_details[department][:total_net]
      @grand_total_basic+= @dept_details[department][:total_basic]
    end
  end

  def department_allowances(department)
    @department_allowances = {:heads => {}, :total => 0.0}
    department[:slips].each do |slip|
      department[slip].allowances.each do |al|
        @department_allowances[:heads][al.salary_head] ||= 0.0
        @department_allowances[:heads][al.salary_head] += al.amount.round
        @department_allowances[:total] += al.amount.try(:round)
      end
    end
    @department_allowances
  end
  
  def department_deductions(department)
    @department_deductions = {:heads => {}, :total => 0.0}
    department[:slips].each do |slip|
      department[slip].deductions.each do |al|
        @department_deductions[:heads][al.salary_head] ||= 0.0
        @department_deductions[:heads][al.salary_head] += al.amount.abs.try(:round)
        @department_deductions[:total] += al.amount.abs.try(:round)
      end
    end
    @department_deductions
  end

  def departments
    @dept_details.values
  end
  
  def month_date
    @salary_sheet.formatted_run_date
  end

  def grand_leaves
    @grand_total_leaves
  end

  def grand_deduction
    @grand_total_deduction
  end

  def grand_gross
    @grand_total_gross
  end

  def grand_net
    @grand_total_net
  end
  
  def grand_basic
    @grand_total_basic
  end

end