require File.dirname(__FILE__) + '/../test_helper'

class CompanyEsisControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => CompanyESI.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    CompanyESI.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    CompanyESI.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to company_esi_url(assigns(:company_esi))
  end
  
  def test_edit
    get :edit, :id => CompanyESI.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    CompanyESI.any_instance.stubs(:valid?).returns(false)
    put :update, :id => CompanyESI.first
    assert_template 'edit'
  end
  
  def test_update_valid
    CompanyESI.any_instance.stubs(:valid?).returns(true)
    put :update, :id => CompanyESI.first
    assert_redirected_to company_esi_url(assigns(:company_esi))
  end
  
  def test_destroy
    company_esi = CompanyESI.first
    delete :destroy, :id => company_esi
    assert_redirected_to company_esis_url
    assert !CompanyESI.exists?(company_esi.id)
  end
end
