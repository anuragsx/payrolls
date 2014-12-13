require File.dirname(__FILE__) + '/../test_helper'

class CompanyPfsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => CompanyPf.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    CompanyPf.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    CompanyPf.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to company_pf_url(assigns(:company_pf))
  end
  
  def test_edit
    get :edit, :id => CompanyPf.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    CompanyPf.any_instance.stubs(:valid?).returns(false)
    put :update, :id => CompanyPf.first
    assert_template 'edit'
  end
  
  def test_update_valid
    CompanyPf.any_instance.stubs(:valid?).returns(true)
    put :update, :id => CompanyPf.first
    assert_redirected_to company_pf_url(assigns(:company_pf))
  end
  
  def test_destroy
    company_pf = CompanyPf.first
    delete :destroy, :id => company_pf
    assert_redirected_to company_pfs_url
    assert !CompanyPf.exists?(company_pf.id)
  end
end
