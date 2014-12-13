require File.dirname(__FILE__) + '/../test_helper'

class FlexibleAllowanceCalculatorTest < ActiveSupport::TestCase

  def test_calculate
    setup_simple_leave
    # Percentage Of Basic and fixed for employee
    hra = SalaryHead.code_for_rent
    med = SalaryHead.code_for_medical
    tvl = SalaryHead.code_for_conveyance
    da = SalaryHead.code_for_da
    Factory(:company_allowance_head, :company => @company, :salary_head => hra)
    Factory(:company_allowance_head, :company => @company, :salary_head => med)
    Factory(:company_allowance_head, :company => @company, :salary_head => tvl)
    Factory(:company_allowance_head, :company => @company, :salary_head => da)
    
    med_employee_company_flexi_package = Factory(:company_flexi_package, :company => @company,
                                             :lookup_expression => "Employee", :salary_head=>med)
    tvl_employee_company_flexi_package = Factory(:company_flexi_package, :company => @company,
                                             :lookup_expression => "Employee", :salary_head=>tvl)
    hra_company_company_flexi_package = Factory(:company_flexi_package, :company => @company,
                                            :lookup_expression => "Company", :salary_head => hra)
    da_company_company_flexi_package = Factory(:company_flexi_package, :company => @company,
                                            :lookup_expression => "Company", :salary_head => da)
    Factory(:percent_of_basic_flexible_allowance, :company => @company,
             :company_flexi_package => hra_company_company_flexi_package,
             :head_type => 'Percentage Of Basic', :salary_head => hra, :category => @company, :value => 10)

    # Percentage Of Basic and optional for employee
          
    Factory(:constant_flexible_allowance, :company => @company,
             :company_flexi_package => med_employee_company_flexi_package,
             :salary_head => med, :value => 500, :category => @employee)

    # Not optional taking the fixed amount provided by flexi package
    
    

    Factory(:constant_flexible_allowance, :company => @company, :head_type => 'Constant',
            :company_flexi_package => tvl_employee_company_flexi_package,
            :salary_head => tvl, :category => @employee, :value => 600)

    # Its options so taking employees package amount
    
    

    Factory(:constant_flexible_allowance, :company => @company, :head_type => 'Constant',
            :company_flexi_package => da_company_company_flexi_package,
            :salary_head => da, :category => @company, :value => 700)
    #FlexibleAllowance.all.each do |f|
    #  p f
    #end
    sheet = Factory(:salary_sheet, :run_date => @run_date, :company => @company)
    slip = sheet.salary_slips.first
    charges = slip.salary_slip_charges
    charges.each do |ch|
      assert_kind_of(SalarySlipCharge, ch)
    end
    assert_kind_of(Array, charges)
    assert_equal(5, charges.length)
    assert_equal(1000, slip.billed_charge_for(hra))
    assert_equal(700, slip.billed_charge_for(da))
    assert_equal(500, slip.billed_charge_for(med))
    assert_equal(600, slip.billed_charge_for(tvl))
  end


  private

  def setup_simple_leave
    @run_date = Date.new(2009, 7, Time.days_in_month(7,2009)) # Tested for july 31 days
    @company = Factory(:company)
    @employee = Factory(:employee, :company => @company, :commencement_date => @run_date.beginning_of_month)
    @emp_p = Factory(:employee_package, :employee => @employee, :company => @company,
            :basic => 10000, :start_date => @employee.commencement_date)
    Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:flexi_allowance_company_calculator, :company => @company, :position =>  2 )
  end

end
