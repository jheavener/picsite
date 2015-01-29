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
    assert_routing signout_path, { controller: 'sessions', action: 'update' }
    
    user = users(:with_email)
    post :create, session: { username: user.display_name, password: 'password' }
    assert @controller.signed_in?
    
    get :update
    assert !@controller.signed_in?
    assert_redirected_to root_path
  end
  
  test "should get index" do
    assert_routing user_sessions_path, { controller: 'sessions', action: 'index' }
    
    user = users(:with_email)
    @controller.send(:signin, user)
    get :index
    assert_response :success
    assert assigns(:user_sessions)
  end
  
  test "should redirect index to signin" do
    get :index
    assert_redirected_to signin_path
  end
  
  test "should get destroy" do
    user = users(:with_email)
    @controller.send(:signin, user)
    user_session_id = @controller.get_user_session
    assert_routing({ method: 'delete', path: user_session_path(user_session_id) }, { controller: 'sessions', action: 'destroy', id: user_session_id })
    
    delete :destroy, { id: user_session_id }
    assert_redirected_to user_sessions_path
    assert_equal 'Session successfully deleted.', flash[:notice]
    
    user_session = UserSession.find(user_session_id)
    assert_not_nil user_session
    assert_equal 'deleted', user_session.status
  end
end
