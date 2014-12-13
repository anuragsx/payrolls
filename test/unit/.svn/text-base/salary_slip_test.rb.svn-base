require File.dirname(__FILE__) + '/../test_helper'

class SalarySlipTest < ActiveSupport::TestCase

  should_belong_to :employee
  should_belong_to :company
  should_belong_to :salary_sheet

  should_have_many :salary_slip_charges
  should_have_many :employee_charges
  should_have_many :allowance_charges
  should_have_many :deduction_charges

  should_have_named_scope "in_fy('2008')", :conditions => {:financial_year => '2008'}

  def setup
    @company = Factory(:company)
    #2.times do |i|
    #  @employee = Factory(:employee, :company => @company, :employee_status => @employee_status)
    #  Factory(:employee_package, :company => @company, :employee => @employee,:basic => 10000.00 * i)
    #end
    Factory(:simple_leave_company_calculator, :company => @company, :position =>  1 )
    Factory(:basic_company_calculator, :company => @company, :position => 2 )
    Factory(:company_pf, :company => @company)
    Factory(:pf_company_calculator, :company => @company, :position => 3 )
  end

  def test_generate_charges
    @employee = Factory(:employee, :company => @company)
    Factory(:employee_package, :company => @company, :employee => @employee,:basic => 10000.00)
    slips  = Factory(:salary_sheet, :run_date => Date.today - 1, :company => @company).salary_slips
    assert_not_nil(slips)
    assert_kind_of(Array, slips)
    slips.each do |slip|
      slip.salary_slip_charges.each do |ch|
        assert_not_nil ch
      end
    end
    
  end

end
