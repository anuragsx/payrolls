require 'test_helper'

class ArrearsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:arrears)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create arrear" do
    assert_difference('Arrear.count') do
      post :create, :arrear => { }
    end

    assert_redirected_to arrear_path(assigns(:arrear))
  end

  test "should show arrear" do
    get :show, :id => arrears(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => arrears(:one).to_param
    assert_response :success
  end

  test "should update arrear" do
    put :update, :id => arrears(:one).to_param, :arrear => { }
    assert_redirected_to arrear_path(assigns(:arrear))
  end

  test "should destroy arrear" do
    assert_difference('Arrear.count', -1) do
      delete :destroy, :id => arrears(:one).to_param
    end

    assert_redirected_to arrears_path
  end
end
