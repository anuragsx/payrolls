require 'test_helper'

class LtaClaimsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lta_claims)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lta_claim" do
    assert_difference('LtaClaim.count') do
      post :create, :lta_claim => { }
    end

    assert_redirected_to lta_claim_path(assigns(:lta_claim))
  end

  test "should show lta_claim" do
    get :show, :id => lta_claims(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => lta_claims(:one).to_param
    assert_response :success
  end

  test "should update lta_claim" do
    put :update, :id => lta_claims(:one).to_param, :lta_claim => { }
    assert_redirected_to lta_claim_path(assigns(:lta_claim))
  end

  test "should destroy lta_claim" do
    assert_difference('LtaClaim.count', -1) do
      delete :destroy, :id => lta_claims(:one).to_param
    end

    assert_redirected_to lta_claims_path
  end
end
