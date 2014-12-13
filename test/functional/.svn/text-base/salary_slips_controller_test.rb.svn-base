require File.dirname(__FILE__) + '/../test_helper'

class SalarySlipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:salary_slips)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create salary_slip" do
    assert_difference('SalarySlip.count') do
      post :create, :salary_slip => { }
    end

    assert_redirected_to salary_slip_path(assigns(:salary_slip))
  end

  test "should show salary_slip" do
    get :show, :id => salary_slips(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => salary_slips(:one).to_param
    assert_response :success
  end

  test "should update salary_slip" do
    put :update, :id => salary_slips(:one).to_param, :salary_slip => { }
    assert_redirected_to salary_slip_path(assigns(:salary_slip))
  end

  test "should destroy salary_slip" do
    assert_difference('SalarySlip.count', -1) do
      delete :destroy, :id => salary_slips(:one).to_param
    end

    assert_redirected_to salary_slips_path
  end
end
