require File.dirname(__FILE__) + '/../test_helper'

class PfCalculatorTest < ActiveSupport::TestCase
  
  def test_calculate_when_private_plan
    setup_simple_leave
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    c_pf = Factory(:private_company_pf, :company => @company)
    Factory(:pf_company_calculator, :company => @company)
    Factory(:employee_pension, :employee => @employee,
            :company => @company,:created_at => @run_date - 1, :company_pf =>  c_pf)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    slip_charges = slip.salary_slip_charges
    sheet_charges = sheet.salary_slip_charges
    slip_charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, slip_charges)
    assert_equal(4, slip_charges.length)
    assert_equal(7, sheet_charges.length)
    assert_equal(slip.gross, 10000.0)
    assert_equal(slip.net, 9220.0)
    assert_equal(slip.deduction, -780.0)
    assert_equal(72.0, sheet.billed_charge_for(SalaryHead.code_for_employer_pf_admin))
    assert_equal(33.0, sheet.billed_charge_for(SalaryHead.code_for_employer_pf_edli))
    assert_equal(1.0, sheet.billed_charge_for(SalaryHead.code_for_employer_pf_inspection))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_vpf))
    assert_equal(541.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf))
    assert_equal(239.0, slip.billed_charge_for(SalaryHead.code_for_employer_epf))
    assert_equal(780.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf).abs)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_epf))
  end

  def test_calculate_when_govt_plan
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    c_pf = Factory(:govt_company_pf, :company => @company)
    Factory(:pf_company_calculator, :company => @company)
    Factory(:employee_pension, :employee => @employee,
            :company => @company,:created_at => @run_date - 1, :company_pf =>  c_pf)
    Factory(:employee_package, :employee => @employee, :company => @company, :basic => 10000,
            :start_date => @employee.commencement_date)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company )
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(3, charges.length)
    assert_equal(slip.gross, 10000.0)
    assert_equal(slip.net, 9167.0)
    assert_equal(slip.deduction, -833.0)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_pension_edli_contrib_head))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_vpf))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_inspection))
    assert_equal(833.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf))
  end

  def test_calculate_when_govt_plan_and_da
    setup_simple_leave
    da = SalaryHead.code_for_da
    hra = SalaryHead.code_for_rent
    Factory(:simple_allowance_company_calculator,  :company => @company, :position =>  2 )
    Factory(:company_allowance_head, :salary_head => da, :company => @company)
    Factory(:company_allowance_head, :salary_head => hra, :company => @company)
    c_pf = Factory(:govt_company_pf, :company => @company)
    Factory(:pf_company_calculator, :company => @company)
    Factory(:employee_pension, :employee => @employee,
            :company => @company,:created_at => @run_date - 1, :company_pf =>  c_pf)
    Factory(:employee_package_head, :employee => @employee, :employee_package => @emp_p,
      :company => @company, :amount => 300, :salary_head => da)
    Factory(:employee_package_head, :employee => @employee, :employee_package => @emp_p,
      :company => @company, :amount => 1300, :salary_head => hra)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(5, charges.length)
    assert_equal(slip.gross, 11600.0) # Basic + da
    assert_equal(slip.net, 10767.0)
    assert_equal(slip.deduction, -833.0)
    assert_equal(1300.0, slip.billed_charge_for(SalaryHead.code_for_rent))
    assert_equal(300.0, slip.billed_charge_for(SalaryHead.code_for_da))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_edli))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_vpf))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_inspection))
    assert_equal(845.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf))
  end

  def test_calculate_when_private_plan_and_lower_then_basic_threashold
    setup_simple_leave
    EmployeePackage.find_by_employee_id(@employee).destroy
    @employee.reload
    Factory(:employee_package, :employee => @employee, :company => @company,
      :basic => 5000, :start_date => @employee.commencement_date)
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    c_pf = Factory(:private_company_pf, :company => @company)
    Factory(:pf_company_calculator, :company => @company)
    Factory(:employee_pension, :employee => @employee,
            :company => @company,:created_at => @run_date - 1, :company_pf =>  c_pf)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(4, charges.length)
    assert_equal(slip.gross, 5000.0)
    assert_equal(slip.net, 4400.0)
    assert_equal(slip.deduction, -600.0)
    assert_equal(55.0, sheet.billed_charge_for(SalaryHead.code_for_employer_pf_admin))
    assert_equal(25.0, sheet.billed_charge_for(SalaryHead.code_for_employer_pf_edli))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_vpf))
    assert_equal(1.0, sheet.billed_charge_for(SalaryHead.code_for_employer_pf_inspection))
    assert_equal(417.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf))
    assert_equal(183.0, slip.billed_charge_for(SalaryHead.code_for_employer_epf))
    assert_equal(600.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf).abs)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_epf))
  end


  def test_calculate_when_govt_plan_when_have_voluntary_amount
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    c_pf = Factory(:govt_company_pf, :company => @company)
    Factory(:pf_company_calculator, :company => @company)
    Factory(:employee_pension, :employee => @employee,
        :company => @company,:created_at => @run_date - 1, :company_pf =>  c_pf)
    EmployeePension.find_by_employee_id(@employee.id).update_attribute(:vpf_amount, 5000)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(4, charges.length)
    assert_equal(slip.gross, 10000.0)
    assert_equal(slip.net, 4167.0)
    assert_equal(slip.deduction, -5833.0)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_admin))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_edli))
    assert_equal(5000.0, slip.billed_charge_for(SalaryHead.code_for_employee_vpf).abs) # Amount in Excess
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_inspection))
    assert_equal(833.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_epf))
    assert_equal(833.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf).abs)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_epf))
  end

  def test_calculate_when_govt_plan_when_have_total_amount_is_greater_then_pf_amount
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    c_pf = Factory(:govt_company_pf, :company => @company)
    Factory(:pf_company_calculator, :company => @company)
    Factory(:employee_pension, :employee => @employee,
        :company => @company,:created_at => @run_date - 1, :company_pf =>  c_pf)
    EmployeePension.for_employee(@employee).for_date(@run_date).last.update_attribute(:total_pf_contribution, 5000)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(4, charges.length)
    assert_equal(slip.gross, 10000.0)
    assert_equal(slip.net, 5000.0)
    assert_equal(slip.deduction, -5000.0)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_admin))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_edli))
    assert_equal(4167.0, slip.billed_charge_for(SalaryHead.code_for_employee_vpf).abs) # Amount in Excess
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_inspection))
    assert_equal(833.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_epf))
    assert_equal(833.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf).abs)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_epf))
  end

  def test_calculate_when_govt_plan_when_have_total_amount_is_less_then_pf_amount
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    c_pf = Factory(:govt_company_pf, :company => @company)
    Factory(:pf_company_calculator, :company => @company)
    Factory(:employee_pension, :employee => @employee,
        :company => @company,:created_at => @run_date - 1, :company_pf =>  c_pf)
    EmployeePension.find_by_employee_id(@employee.id).update_attribute(:total_pf_contribution, 500)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(3, charges.length)
    assert_equal(slip.gross, 10000.0)
    assert_equal(slip.net, 9167.0)
    assert_equal(slip.deduction, -833.0)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_admin))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_edli))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_vpf).abs) # Amount in Excess
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf_inspection))
    assert_equal(833.0, slip.billed_charge_for(SalaryHead.code_for_employer_pf))
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employer_epf))
    assert_equal(833.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf).abs)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_pf) +
        slip.billed_charge_for(SalaryHead.code_for_employer_epf))
  end

  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009))
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @emp_p = Factory(:employee_package, :employee => @employee, :company => @company, :basic => 10000, :start_date => @employee.commencement_date)
    @leave_calculator = Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
  end

end
