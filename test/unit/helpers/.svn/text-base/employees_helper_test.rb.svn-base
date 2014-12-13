require File.dirname(__FILE__) + '/../../test_helper'

class EmployeesHelperTest < ActionView::TestCase

  def test_fetch_data
    employee = Factory(:employee)
    output = fetch_data(employee)
    assert output
    assert_equal("<span class='label label-added'>Added</span>",output)
  end

  def test_all_active_employees
    @company = Factory(:company)
    Factory(:employee, :company => @company)
    output = all_active_employees
    assert output
  end

  def test_highlight_lastname
    output = highlight_lastname("Swati Verma")
    assert output
    assert_equal("Swati <strong>Verma</strong>", output)
  end


  def test_employee_links
    @company = Factory(:company)
    Factory(:simple_leave_company_calculator, :company => @company)
    Factory(:dearness_relief_company_calculator, :company => @company)
    Factory(:esi_company_calculator, :company => @company)
    @employee = Factory(:employee, :company => @company)
    output = employee_links
    assert output
  end

  def test_employee_header_defaults
    @employee = Factory(:employee)
    output = employee_header_defaults
    assert output
  end

  def test_calculate_percent
    output = calculate_percent
    assert output
    assert_equal("0.00", output)    
  end

  def test_horizontal_graph
    output = horizontal_graph(horizontal_graph([[2,3],[4,7]]))
    assert output
  end

  def test_setup
    emp = Factory(:employee)
    output = employee_setup(emp)
    assert output
  end

  def link_active?(bool_condition = false)
    (bool_condition && "active") || ""
  end

  def params
    { :controller => 'employees', :search => {:status => "Active"}}
  end

  def test_employee_status_header   
    output = employee_status_header
    assert output
  end

  def test_not_active_status
    output = active_status?
    assert !output   
  end
  
end
