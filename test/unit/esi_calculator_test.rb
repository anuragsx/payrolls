require File.dirname(__FILE__) + '/../test_helper'

class EsiCalculatorTest < ActiveSupport::TestCase
  
  def test_calculate_when_shop_act
    setup_simple_leave
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:shop_company_esi, :company => @company)
    Factory(:esi_company_calculator, :company => @company)
    Factory(:employee_esi, :company => @company, :employee=> @employee,
            :effective_date => @employee.commencement_date)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(3, sheet.salary_slip_charges.length)
    assert_equal(10000.0, slip.gross)
    assert_equal(9825.0, slip.net)
    assert_equal(slip.deduction.abs, 175.0)
    assert_equal(175.0, slip.billed_charge_for(SalaryHead.code_for_employee_esi).abs)
    assert_equal(475.0, sheet.billed_charge_for(SalaryHead.code_for_employer_esi).abs)
  end

  def test_calculate_when_factory_act_basic_greater_then_basic_threshold_but_applicable
    setup_simple_leave
    EmployeePackage.find_by_employee_id(@employee).destroy
    Factory(:employee_package, :employee => @employee, :company => @company,
            :basic => 15000, :start_date => @employee.commencement_date)
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:factory_company_esi, :company => @company)
    Factory(:esi_company_calculator, :company => @company)
    Factory(:employee_esi, :company => @company, :employee=> @employee,
            :effective_date => @employee.commencement_date)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(15000.0, slip.gross)
    assert_equal(14737.0, slip.net)
    assert_equal(slip.deduction.abs, 263.0)
    assert_equal(263.0, slip.billed_charge_for(SalaryHead.code_for_employee_esi).abs)
    assert_equal(713.0, sheet.billed_charge_for(SalaryHead.code_for_employer_esi).abs)
  end


  def test_calculate_when_shop_act_basic_greater_then_basic_threshold_and_not_applicable
    setup_simple_leave
    EmployeePackage.find_by_employee_id(@employee).destroy
    Factory(:employee_package, :employee => @employee, :company => @company,
            :basic => 15000, :start_date => @employee.commencement_date)
    Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:shop_company_esi, :company => @company)
    Factory(:esi_company_calculator, :company => @company)
    Factory(:employee_esi, :company => @company, :employee=> @employee,
            :effective_date => @employee.commencement_date, :applicable => false)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company=> @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(1, charges.length)
    assert_equal(15000.0, slip.gross)
    assert_equal(15000.0, slip.net)
    assert_equal(slip.deduction.abs, 0.0)
    assert_equal(0.0, slip.billed_charge_for(SalaryHead.code_for_employee_esi).abs)
    assert_equal(0.0, sheet.billed_charge_for(SalaryHead.code_for_employer_esi).abs)
  end

  def test_calculate_when_factory_act
    setup_simple_leave
    @basiccc = Factory(:basic_company_calculator,  :company => @company, :position =>  2 )
    Factory(:factory_company_esi, :company => @company)
    Factory(:esi_company_calculator, :company => @company)
    Factory(:employee_esi, :company => @company, :employee=> @employee,
            :effective_date => @employee.commencement_date)
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(2, charges.length)
    assert_equal(3, sheet.salary_slip_charges.length)
    assert_equal(10000.0, slip.gross)
    assert_equal(9825.0, slip.net)
    assert_equal(slip.deduction.abs, 175.0)
    assert_equal(175.0, slip.billed_charge_for(SalaryHead.code_for_employee_esi).abs)
    assert_equal(475.0, sheet.billed_charge_for(SalaryHead.code_for_employer_esi).abs)
  end

  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009)) # Tested for july 31 days
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    Factory(:employee_package, :employee => @employee, :company => @company,
            :basic => 10000, :start_date => @employee.commencement_date)
    Factory(:simple_leave_company_calculator, :company => @company, :position =>  1)
  end

end
