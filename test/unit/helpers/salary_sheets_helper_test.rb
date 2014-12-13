require File.dirname(__FILE__) + '/../../test_helper'

class SalarySheetsHelperTest < ActionView::TestCase

  def setup
    @company = Factory(:company)
    Factory(:leave_accounting_company_calculator, :company => @company)
    Factory(:basic_company_calculator, :company => @company)
    Factory(:company_leave, :company => @company)
    @employee = Factory(:employee, :company => @company)
    Factory(:employee_package, :company => @company, :employee => @employee)
    @employee.reload
    Factory(:employee_leave_balance, :employee => @employee, :company => @company)
    slip = Factory(:salary_slip, :company => @company, :employee => @employee)
    @salary_slip = SalarySlipPresenter.new(slip)
  end

  def test_get_action_for
    @salary_sheet = Factory(:salary_sheet)
    output = get_action_for(@salary_sheet)
    assert output
    assert_equal("Finalize Salary Sheet", output)
  end

  def test_allowances   
    output = allowances(@salary_slip)
    amount = sprintf('%.2f', @salary_slip.allowances.first.amount)
    assert output.include?(amount)
    assert output.include?("Basic:")
    assert output.include?("<br/>")
    assert output.include?("<b>")
    assert output.include?("<i>")
    assert output.include?("Gross:")
  end
  
  def test_deductions
    # we dont have deductions 
    output = deductions(@salary_slip)
    amount = @salary_slip.deductions.first.try(:amount)
    assert_nil amount
    assert output
    assert output.include?("<br/>")
    assert output.include?("<b>")
    assert output.include?("<i>")
    assert output.include?("Total:")
  end
  
  def test_salaries_links
    output = salaries_links
    assert output
  end

  def params
    { :controller => "salary_sheets"}
  end

  def link_active?(bool_condition = false)
    (bool_condition && "active") || ""
  end

  def test_salaries_sub_header
    @salary_sheet = Factory(:salary_sheet)
    output = salaries_sub_header
    assert output
  end

  def test_salary_sheet_actions
    @salary_sheet = Factory(:salary_sheet)
    output = salary_sheet_actions(@salary_sheet)
    assert output
  end

  def link_active?(bool_condition = false)
    (bool_condition && "active") || ""
  end

  def params
    { :controller => 'salary_sheets'}
  end


  def test_salaries_sub_header
    @salary_sheet = Factory(:salary_sheet)
    output = salaries_sub_header
    assert output    
  end
  
end
