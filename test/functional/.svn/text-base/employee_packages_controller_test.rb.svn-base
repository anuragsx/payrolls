require File.dirname(__FILE__) + '/../test_helper'

class EmployeePackagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_packages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee_package" do
    assert_difference('EmployeePackage.count') do
      post :create, :employee_package => { }
    end

    assert_redirected_to employee_package_path(assigns(:employee_package))
  end

  test "should show employee_package" do
    get :show, :id => employee_packages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => employee_packages(:one).to_param
    assert_response :success
  end

  test "should update employee_package" do
    put :update, :id => employee_packages(:one).to_param, :employee_package => { }
    assert_redirected_to employee_package_path(assigns(:employee_package))
  end

  test "should destroy employee_package" do
    assert_difference('EmployeePackage.count', -1) do
      delete :destroy, :id => employee_packages(:one).to_param
    end

    assert_redirected_to employee_packages_path
  end
end
