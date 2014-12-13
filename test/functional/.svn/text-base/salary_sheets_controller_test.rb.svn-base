require File.dirname(__FILE__) + '/../test_helper'

class SalarySheetsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:salary_sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create salary_sheet" do
    assert_difference('SalarySheet.count') do
      post :create, :salary_sheet => { }
    end

    assert_redirected_to salary_sheet_path(assigns(:salary_sheet))
  end

  test "should show salary_sheet" do
    get :show, :id => salary_sheets(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => salary_sheets(:one).to_param
    assert_response :success
  end

  test "should update salary_sheet" do
    put :update, :id => salary_sheets(:one).to_param, :salary_sheet => { }
    assert_redirected_to salary_sheet_path(assigns(:salary_sheet))
  end

  test "should destroy salary_sheet" do
    assert_difference('SalarySheet.count', -1) do
      delete :destroy, :id => salary_sheets(:one).to_param
    end

    assert_redirected_to salary_sheets_path
  end
end
