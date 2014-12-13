require 'test_helper'

class TdsReturnsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tds_returns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tds_return" do
    assert_difference('TdsReturn.count') do
      post :create, :tds_return => { }
    end

    assert_redirected_to tds_return_path(assigns(:tds_return))
  end

  test "should show tds_return" do
    get :show, :id => tds_returns(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tds_returns(:one).to_param
    assert_response :success
  end

  test "should update tds_return" do
    put :update, :id => tds_returns(:one).to_param, :tds_return => { }
    assert_redirected_to tds_return_path(assigns(:tds_return))
  end

  test "should destroy tds_return" do
    assert_difference('TdsReturn.count', -1) do
      delete :destroy, :id => tds_returns(:one).to_param
    end

    assert_redirected_to tds_returns_path
  end
end
