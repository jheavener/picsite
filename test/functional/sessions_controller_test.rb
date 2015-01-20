require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should show signin form" do
    assert_routing signin_path, { controller: 'sessions', action: 'new' }
    
    get :new
    assert_response :success
  end

  test "should signin user" do
    assert_routing({ method: 'post', path: signin_path }, { controller: 'sessions', action: 'create' })
    
    user = users(:with_email)
    post :create, session: { username: user.display_name, password: 'password' }
    assert @controller.signed_in?
    assert_redirected_to root_path
  end
  
  test "should show signin error" do
    post :create, session: {}
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:error)
  end
  
  test "should signout user" do
    assert_routing signout_path, { controller: 'sessions', action: 'destroy' }
    
    user = users(:with_email)
    post :create, session: { username: user.display_name, password: 'password' }
    assert @controller.signed_in?
    
    get :destroy
    assert !@controller.signed_in?
    assert_redirected_to root_path
  end
end
