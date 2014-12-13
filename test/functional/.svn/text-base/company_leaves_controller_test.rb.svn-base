require File.dirname(__FILE__) + '/../test_helper'

class CompanyLeavesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => CompanyLeave.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    CompanyLeave.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    CompanyLeave.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to company_leave_url(assigns(:company_leave))
  end
  
  def test_edit
    get :edit, :id => CompanyLeave.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    CompanyLeave.any_instance.stubs(:valid?).returns(false)
    put :update, :id => CompanyLeave.first
    assert_template 'edit'
  end
  
  def test_update_valid
    CompanyLeave.any_instance.stubs(:valid?).returns(true)
    put :update, :id => CompanyLeave.first
    assert_redirected_to company_leave_url(assigns(:company_leave))
  end
  
  def test_destroy
    company_leave = CompanyLeave.first
    delete :destroy, :id => company_leave
    assert_redirected_to company_leaves_url
    assert !CompanyLeave.exists?(company_leave.id)
  end
end
