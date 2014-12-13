require File.dirname(__FILE__) + '/../test_helper'

class EmployeeLeaveTest < ActiveSupport::TestCase

  should_belong_to :company, :employee, :salary_slip, :salary_sheet
  should_validate_presence_of :company_id, :employee_id, :present, :absent
  should_validate_numericality_of :present, :absent, :paid, :unpaid

  should_have_named_scope "for_company(1)", :conditions => ["company_id = ?",1]
  should_have_named_scope "for_employee(1)", :conditions => ["employee_id = ?",1]
  should_have_named_scope "for_month(Date.today)", :conditions => ["month(created_at) = ? and year(created_at) = ?",Date.today.month,Date.today.year]
  should_have_named_scope "unbilled", :conditions =>  ["salary_slip_id is null"]
  should_have_named_scope "for_salary_slip(1)", :conditions => ["salary_slip_id = ?",1]
  should_have_named_scope "in_years(1)", :conditions => ["year(created_at) in (?)",1]
  should_have_named_scope "in_months(1)", :conditions => ["month(created_at) in (?)",1]
  should_have_named_scope "for_year(1)", :conditions => ["year(created_at) = ?",1]


  def test_absent_days_and_present_days
    setup_employee_leave
    assert_equal 0, @employee_leave.absent_days
    assert_equal 0, @employee_leave.present_days
    employee_leave = Factory(:employee_leave, :company => @company, :absent => 12,:present => 12)
    assert_equal 12, employee_leave.absent_days
    assert_equal 12, employee_leave.present_days
  end

  def test_days_in_month_if_simple_leave_calculator
    setup_simple_leave_calculator
		create_sheet
    assert_equal 31, @employee_leave.days_in_month
  end

  def test_days_in_month_if_leave_accounting_calculator_and_not_have_company_info
    setup_employee_leave
    setup_simple_leave_accounting_calculator
    assert_nil @employee_leave.company_info
    assert_nil @employee_leave.days_in_month
  end

  def test_days_in_month_if_leave_accounting_calculator_and_have_company_info
    setup_employee_leave
    setup_company_info
    setup_simple_leave_accounting_calculator
    assert_not_nil @employee_leave.company_info
    assert_equal 31, @employee_leave.days_in_month
  end

  def test_holidays
    setup_simple_leave_calculator
		create_sheet
    assert_equal 0, @employee_leave.absent_days
    assert_equal 0, @employee_leave.present_days
    assert_equal 31, @employee_leave.holidays
  end

  def test_earnings_if_have_simple_leave_calculator
    setup_simple_leave_calculator
    assert_equal 0, @employee_leave.earning
  end

  def test_earnings_if_have_leave_accounting_calculator
    setup_employee_leave
    setup_company_info
    setup_simple_leave_accounting_calculator
    assert_equal 0, @employee_leave.earning
  end

  def test_earnings_if_have_leave_accounting_calculator_and_have_presents
    @run_date = Date.parse("31 oct 2009")
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @employee_leave = Factory(:employee_leave, :company => @company, :employee => @employee, :present => 20)
    setup_company_info
    setup_simple_leave_accounting_calculator
    @employee_leave.reload
    @company.reload
    assert_equal(true, @company.has_calculator?(LeaveAccountingCalculator))
    assert_equal 1, @employee_leave.earning
  end

  def test_should_run_date
		setup_simple_leave_calculator
		create_sheet
    assert_equal @run_date, @employee_leave.run_date
  end

  def test_leave_balance_when_not_have_leave_accouting_calculator
		setup_simple_leave_calculator
		@company.reload
		assert_equal(false, @company.has_calculator?(LeaveAccountingCalculator))
		assert_nil @employee_leave.leave_balance
  end

  def test_leave_balance_when_we_have_leave_accouting_calculator_and_earn_now_consume_next_year
    setup_employee_leave
    setup_company_info
    setup_simple_leave_accounting_calculator
		@company.reload
		assert_equal false,@company_leave.accrue_as_you_go?
		assert_equal(true, @company.has_calculator?(LeaveAccountingCalculator))
		assert_not_nil @employee_leave.leave_balance
  end

  def test_leave_balance_when_we_have_leave_accouting_calculator_and_accrue_as_you_go
    setup_employee_leave
    @company_leave = Factory(:company_leave,:company => @company, :rate_of_leave => 20, :leave_accrual => 2)
    setup_simple_leave_accounting_calculator
    @company.reload
    assert_equal true,@company_leave.accrue_as_you_go?
    assert_equal(true, @company.has_calculator?(LeaveAccountingCalculator))
    assert_not_nil @employee_leave.leave_balance
  end

  def test_should_have_nil_earned_balance_when_have_simple_leave_calculator
		setup_simple_leave_calculator
		assert_nil EmployeeLeave.earned_leaves(@employee)
  end

  def test_should_have_earned_balance_when_have_leave_accounting_calculator_and_earn_now_consume_next_year
    setup_employee_leave
    setup_company_info
    setup_simple_leave_accounting_calculator
		@company.reload
		assert_equal false,@company_leave.accrue_as_you_go?
		assert_equal(true, @company.has_calculator?(LeaveAccountingCalculator))
		assert_not_nil EmployeeLeave.earned_leaves(@employee)
  end

  def test_should_have_earned_balance_when_have_leave_accounting_calculator_and_accrue_as_you_go
    setup_employee_leave
    @company_leave = Factory(:company_leave,:company => @company, :rate_of_leave => 20, :leave_accrual => 2)
    setup_simple_leave_accounting_calculator
    @company.reload
		@employee.reload
    assert_equal true,@company_leave.accrue_as_you_go?
    assert_equal(true, @company.has_calculator?(LeaveAccountingCalculator))
    assert_not_nil @employee_leave.leave_balance
		assert_not_nil EmployeeLeave.earned_leaves(@employee)
  end

  def test_should_employee_leave_applicable_days_and_have_no_effective_package
		setup_company
		@employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
		@emp_p = Factory(:employee_package, :employee => @employee, :company => @company,
			:basic => 10000, :start_date => (@employee.commencement_date + 1.months))
		@employee_leave ||= Factory(:employee_leave, :company => @company,
			:created_at => @run_date - 20.days, :employee => @employee)
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
		assert_nil @employee.effective_package(@run_date)
		assert_equal 31, EmployeeLeave.applicable_days(@employee, @run_date)
  end
	
  def test_should_employee_leave_applicable_days_when_have_old_charges
		setup_company
		@employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month - 4.months)
		assert_equal Date.parse("1 Jun 2009"), @employee.commencement_date
		@emp_p = Factory(:employee_package, :employee => @employee, :company => @company,
			:basic => 10000, :start_date => (@employee.commencement_date))
		assert_equal Date.parse("1 Jun 2009"), @emp_p.start_date	
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
		
		run_date1 = @run_date - 3.months
		assert_equal 61, EmployeeLeave.applicable_days(@employee, run_date1)
		sheet1 = create_sheet(run_date1)
		assert_equal sheet1.run_date, Date.parse("31 jul 2009")
		
		run_date2 = @run_date - 2.months
		assert_equal 31, EmployeeLeave.applicable_days(@employee, run_date2)
		sheet2 = create_sheet(run_date2)
		assert_equal sheet2.run_date, Date.parse("31 Aug 2009")

		# Skip augest
			
		@employee.reload
		assert_equal 61, EmployeeLeave.applicable_days(@employee, @run_date)
  end

  def test_should_employee_leave_applicable_days_when_have_old_charges_and_start_date_between_month
		setup_company
		@employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month - 4.months + 2.days)
		assert_equal Date.parse("3 Jun 2009"), @employee.commencement_date
		@emp_p = Factory(:employee_package, :employee => @employee, :company => @company,
			:basic => 10000, :start_date => (@employee.commencement_date), :end_date => Date.parse("25 oct 2009"))
		assert_equal Date.parse("3 Jun 2009"), @emp_p.start_date	
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
		
		run_date1 = @run_date - 3.months
		assert_equal 59, EmployeeLeave.applicable_days(@employee, run_date1)
		sheet1 = create_sheet(run_date1)
		assert_equal sheet1.run_date, Date.parse("31 jul 2009")
		
		run_date2 = @run_date - 2.months
		assert_equal 31, EmployeeLeave.applicable_days(@employee, run_date2)
		sheet2 = create_sheet(run_date2)
		assert_equal sheet2.run_date, Date.parse("31 Aug 2009")

		# Skip augest
			
		@employee.reload
		assert_equal 55, EmployeeLeave.applicable_days(@employee, @run_date)
  end

  def test_uniara_case_when_joined_in_month
		setup_company
		@employee = Factory(:employee, :company => @company, :commencement_date => Date.parse("29 oct 2009"))
		assert_equal Date.parse("29 oct 2009"), @employee.commencement_date
		@emp_p = Factory(:employee_package, :employee => @employee, :company => @company,
			:basic => 10000, :start_date => (@employee.commencement_date))
		assert_equal Date.parse("29 oct 2009"), @emp_p.start_date
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    run_date = Date.parse("31 oct 2009")
		run_date1 = run_date
		assert_equal 3, EmployeeLeave.applicable_days(@employee, run_date1)
		sheet1 = create_sheet(run_date1)
		assert_equal sheet1.run_date, Date.parse("31 oct 2009")
  end
  
  def test_uniara_case_when_resigned_in_month
		setup_company
		@employee = Factory(:employee, :company => @company, :commencement_date => Date.parse("1 sep 2009"))
		assert_equal Date.parse("1 sep 2009"), @employee.commencement_date
		@emp_p = Factory(:employee_package, :employee => @employee, :company => @company,
			:basic => 10000, :start_date => (@employee.commencement_date), :end_date => Date.parse("21 oct 2009"))
		assert_equal Date.parse("1 sep 2009"), @emp_p.start_date
    assert_equal Date.parse("21 oct 2009"), @emp_p.end_date
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )

		run_date2 = Date.parse("30 sep 2009")
		assert_equal 30, EmployeeLeave.applicable_days(@employee, run_date2)
		sheet2 = create_sheet(run_date2)
		assert_equal sheet2.run_date, Date.parse("30 sep 2009")

    run_date = Date.parse("31 oct 2009")
		run_date1 = run_date
		assert_equal 21, EmployeeLeave.applicable_days(@employee, run_date1)
		sheet1 = create_sheet(run_date1)
		assert_equal sheet1.run_date, Date.parse("31 oct 2009")
  end

	def test_should_total_leaves_no_absents
    setup_company
    setup_simple_leave_calculator
    assert_equal 0, @employee_leave.total_leaves
  end
	
	def test_should_total_leaves_with_absents
    setup_company
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @employee_leave ||= Factory(:employee_leave, :company => @company,:absent => 5,
      :created_at => @run_date - 20.days, :employee => @employee)
    assert_equal 5, @employee_leave.total_leaves
  end
  
	def test_should_total_leaves_with_absents_and_late_hours
    setup_company
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @employee_leave ||= Factory(:employee_leave, :company => @company,:absent => 5, :late_hours => 4, :overtime_hours => 5,
      :created_at => @run_date - 20.days, :employee => @employee)
    assert_equal 4.88, @employee_leave.total_leaves
  end

  private

	def	setup_company
    @run_date = Date.parse("31 oct 2009")
    @company = Factory(:company)
	end
	
  def setup_company_info
    @company_leave = Factory(:company_leave,:company => @company, :rate_of_leave => 20)
  end

  def setup_simple_leave_accounting_calculator
    @leave_calculator = Factory(:leave_accounting_company_calculator, :company => @company, :position =>  1 )
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    @sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    @employee_leave.reload
  end

  def setup_simple_leave_calculator
    setup_employee_leave
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
  end

	def	create_sheet(run_date = @run_date)
    @sheet = Factory(:salary_sheet, :run_date => run_date, :company => @company)
    @employee_leave.try(:reload)
		@sheet
	end
	
  def setup_employee_leave
		setup_company
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @emp_p = Factory(:employee_package, :employee => @employee, :company => @company,
      :basic => 10000, :start_date => @employee.commencement_date)
    @employee_leave ||= Factory(:employee_leave, :company => @company,
      :created_at => @run_date - 20.days, :employee => @employee)
  end

end
