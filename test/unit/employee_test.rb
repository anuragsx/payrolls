require File.dirname(__FILE__) + '/../test_helper'

class EmployeeTest < ActiveSupport::TestCase
  
  should_belong_to :company
  should_belong_to :department
  should_belong_to :bank
  should_have_one :employee_detail
  should_have_one :address
  should_have_many :salary_slips
  should_have_many :salary_slip_charges
  should_have_many :referenced_charges

  should_have_named_scope "recent(4)", :limit => 4, :order => "updated_at desc"

  def test_next_possible_events
    setup   
    assert_equal([:activate], @emp.next_possible_events)
    assert_not_nil(@emp.next_possible_events)
  end

  def test_current_package
    setup
    Factory(:employee_package, :employee => @emp, :start_date => @emp.commencement_date, :company => @emp.company)
    @emp.reload
    assert_not_nil(@emp.current_package)
  end

  def test_end_date
    setup
    Factory(:employee_package, :employee => @emp, :start_date => Date.today - 2.days, :company => @emp.company, :end_date => Date.today)
    @emp.reload
    assert_equal(Date.today,@emp.end_date)   
  end

  def test_current_basic
    setup
    Factory(:employee_package, :employee => @emp, :start_date => Date.today - 2.days, :company => @emp.company)
    @emp.reload
    assert_not_nil(@emp.current_basic)
  end

  def test_effective_package_if_have_active_package_and_started_before_month
    setup
    Factory(:employee_package, :employee => @emp,
      :start_date => @run_date - 1.months, :company => @emp.company)
    @emp.reload
    package = @emp.effective_package(@run_date)
    assert package.active?
    assert_not_nil(package)
  end

  def test_effective_package_if_have_active_package_and_started_in_month
    setup
    Factory(:employee_package, :employee => @emp,
      :start_date => @run_date - 20.day, :company => @emp.company)
    @emp.reload
    package = @emp.effective_package(@run_date)
    assert package.active?
    assert_not_nil(package)
  end

  def test_effective_package_if_have_active_package_and_started_after_month
    setup
    Factory(:employee_package, :employee => @emp,
      :start_date => @run_date + 1.months, :company => @emp.company)
    @emp.reload
    package = @emp.effective_package(@run_date)
    assert_nil package # no package for given month
  end

  def test_effective_package_if_no_active_package_and_start_before_and_end_in_month
    setup
    Factory(:employee_package, :employee => @emp,
      :start_date => @run_date - 1.months, :end_date => @run_date - 1.day,:company => @emp.company)
    @emp.reload
    package = @emp.effective_package(@run_date)
    assert package.ended?
    assert_not_nil(package)
  end

  def test_effective_package_if_no_active_package_and_start_before_and_end_before_month
    setup
    Factory(:employee_package, :employee => @emp,
      :start_date => @run_date + 2.months, :end_date => @run_date + 1.months,:company => @emp.company)
    @emp.reload
    package = @emp.effective_package(@run_date)
    assert package.ended?
    assert_not_nil(package)
  end

  def test_effective_package_if_no_active_package_and_start_in_and_end_after_month
    setup
    Factory(:employee_package, :employee => @emp,
      :start_date => @run_date + 1.day, :end_date => @run_date + 1.months,:company => @emp.company)
    @emp.reload
    package = @emp.effective_package(@run_date)
    assert package.ended?
    assert_not_nil(package)
  end

  def test_effective_package_if_no_active_package_and_start_in_and_end_in_month
    setup
    Factory(:employee_package, :employee => @emp,
      :start_date => @run_date - 5.day, :end_date => @run_date - 1.day,:company => @emp.company)
    @emp.reload
    package = @emp.effective_package(@run_date)
    assert package.ended?
    assert_not_nil(package)
  end

  def test_effective_package_if_no_active_package_and_start_before_and_end_after_month
    setup
    Factory(:employee_package, :employee => @emp,
      :start_date => @run_date - 1.months, :end_date => @run_date + 1.months,:company => @emp.company)
    @emp.reload
    package = @emp.effective_package(@run_date)
    assert package.ended?
    assert_not_nil(package)
  end

  def test_effective_package_if_no_active_package_and_start_after_and_end_after_month
    setup
    Factory(:employee_package, :employee => @emp,
      :start_date => @run_date + 1.months, :end_date => @run_date + 2.months,:company => @emp.company)
    @emp.reload
    package = @emp.effective_package(@run_date)
    assert_nil(package)
  end

  def test_effective_basic
    setup
    Factory(:employee_package, :employee => @emp, :start_date => Date.today - 1.months, :company => @emp.company)
    @emp.reload
    assert_not_nil(@emp.effective_basic(Date.today))
  end

  def test_search
    setup
    assert_not_nil(Employee.search({:status_is => "Active"}))
  end

  def test_department_name
    setup
    assert_not_nil(@emp.department_name)
  end

  def test_employee_name
    setup
    assert_not_nil(@emp.employee_name)
  end

  def test_do_suspend
    setup
    Factory(:employee_package, :employee => @emp, :start_date => Date.today - 1.months, :company => @emp.company)
    @emp.reload    
    assert_equal(true, @emp.do_suspend!)
  end

  def test_do_active
    setup
    Factory(:employee_package, :employee => @emp, :start_date => Date.today - 1.months, :company => @emp.company)
    @emp.reload    
    assert_not_nil(@emp.do_active!)
  end

  def test_do_resign
    setup
    Factory(:employee_package, :employee => @emp, :start_date => Date.today - 1.months, :company => @emp.company)
    @emp.reload
    @emp.do_resign!
    @emp.reload
    assert_equal(Date.today,@emp.employee_packages.last.end_date)
  end

  def test_complete_address
    setup
    assert_equal("address_line1, address_line2, address_line3, Jaipur, Pin Code : 302020, Rajasthan", @emp.complete_address)
  end

  def test_sex
    setup
    Factory(:employee_detail, :employee => @emp)    
    @emp.reload
    assert_equal("Male", @emp.sex)
  end

  def test_care_of
    setup
    Factory(:employee_detail, :employee => @emp, :care_of => "address")
    @emp.reload
    assert_equal("address", @emp.care_of)
  end

  private

  def setup
    @emp ||= Factory(:employee)
    @run_date ||= Date.parse('31 oct 2009')
  end
end