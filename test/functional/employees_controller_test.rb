require File.dirname(__FILE__) + '/../test_helper'

class EmployeesControllerTest < ActionController::TestCase

  def setup
    set_up_company
    @controller = EmployeesController.new
    @request    = ActionController::TestRequest.new(:host => 'http://demo.salaree.com')
    @request.host = 'demo.salaree.com'
    @response = ActionController::TestResponse.new
    @employee = Factory(:arun_employee, :company => @company)    
#        Authlogic::Session::Base.controller = EmployeesController.new
#        @current_user = UserSession.new({
#            :login => 'swati',
#            :password => 'swati'}
#        )
    set_session_for(Factory(:user, :company => @company))
  end



  def test_index
    p @employee
    get :index, :search => {:status_is => "Active", :name_like_any => "Arun"}
    assert_response :success
    #assert_redirected_to new_import_employees_path
    #assert_not_nil assigns(:employees)
    assert assigns(:employees)
    assert assigns(:employees).kind_of?(Array)
    
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee" do
    assert_difference('Employee.count') do
      post :create, :employee => { }
    end

    assert_redirected_to employee_path(assigns(:employee))
  end

  def test_show    
    get :show, :id => @employee.id
    assert_response :success
    assert_template 'show'
  end

  test "should get edit" do
    get :edit, :id => employees(:one).to_param
    assert_response :success
  end

  test "should update employee" do
    put :update, :id => employees(:one).to_param, :employee => { }
    assert_redirected_to employee_path(assigns(:employee))
  end

  test "should destroy employee" do
    assert_difference('Employee.count', -1) do
      delete :destroy, :id => employees(:one).to_param
    end

    assert_redirected_to employees_path
  end
end
