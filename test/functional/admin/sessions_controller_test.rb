require 'test_helper'

class Admin::SessionsControllerTest < ActionController::TestCase
  test "should get index" do
    user = users(:with_email)
    assert_routing admin_user_sessions_path(user.to_param), { controller: 'admin/sessions', action: 'index', user_id: user.to_param }
    
    @controller.send(:signin, users(:admin))
    get :index, { user_id: user.to_param }
    assert_response :success
    assert assigns(:user)
    assert assigns(:active_sessions)
    assert assigns(:inactive_sessions)
  end
  
  test "should redirect get index to signin" do
    user = users(:with_email)
    @controller.send(:signin, user)
    get :index, { user_id: user.to_param }
    assert_redirected_to signin_path
  end

  test "should get destroy" do
    user = users(:with_email)
    user_session = user.sessions.create
    assert_routing({ method: 'delete', path: admin_user_session_path(user.to_param, user_session.to_param) }, { controller: 'admin/sessions', action: 'destroy', user_id: user.to_param, id: user_session.to_param })
    
    @controller.send(:signin, users(:admin))
    delete :destroy, { user_id: user.to_param, id: user_session.to_param }
    assert_redirected_to admin_user_sessions_path(user)
    assert_equal 'Session successfully deleted.', flash[:notice]
  end
  
  test "should redirect get destroy to signin" do
    user = users(:with_email)
    user_session = user.sessions.create
    @controller.send(:signin, user)
    delete :destroy, { user_id: user.to_param, id: user_session.to_param }
    assert_redirected_to signin_path
  end
end
