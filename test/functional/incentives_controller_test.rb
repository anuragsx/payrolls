require 'test_helper'

class IncentivesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incentives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incentive" do
    assert_difference('Incentive.count') do
      post :create, :incentive => { }
    end

    assert_redirected_to incentive_path(assigns(:incentive))
  end

  test "should show incentive" do
    get :show, :id => incentives(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => incentives(:one).to_param
    assert_response :success
  end

  test "should update incentive" do
    put :update, :id => incentives(:one).to_param, :incentive => { }
    assert_redirected_to incentive_path(assigns(:incentive))
  end

  test "should destroy incentive" do
    assert_difference('Incentive.count', -1) do
      delete :destroy, :id => incentives(:one).to_param
    end

    assert_redirected_to incentives_path
  end
end
