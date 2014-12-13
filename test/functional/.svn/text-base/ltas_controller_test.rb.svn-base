require 'test_helper'

class LtasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ltas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lta" do
    assert_difference('Lta.count') do
      post :create, :lta => { }
    end

    assert_redirected_to lta_path(assigns(:lta))
  end

  test "should show lta" do
    get :show, :id => ltas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ltas(:one).to_param
    assert_response :success
  end

  test "should update lta" do
    put :update, :id => ltas(:one).to_param, :lta => { }
    assert_redirected_to lta_path(assigns(:lta))
  end

  test "should destroy lta" do
    assert_difference('Lta.count', -1) do
      delete :destroy, :id => ltas(:one).to_param
    end

    assert_redirected_to ltas_path
  end
end
