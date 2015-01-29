require 'test_helper'

class DeleteUserControllerTest < ActionController::TestCase
  test "should get delete_user edit" do
    assert_routing delete_user_path, { controller: 'delete_user', action: 'edit' }
    
    user = users(:with_email)
    @controller.send(:signin, user)
    get :edit
    assert_response :success
    assert_not_nil assigns(:current_user)
  end
  
  test "should redirect delete_user edit to signin" do
    user = users(:with_email)
    get :edit
    assert_redirected_to signin_path
  end
  
  test "should redirect successful delete_user destroy" do
    user = users(:with_email)
    assert_routing({ method: 'delete', path: delete_user_path }, { controller: 'delete_user', action: 'destroy' })
    
    @controller.send(:signin, user)
    delete :destroy, { password: 'password' }
    assert_redirected_to root_path
    assert_equal 'Your account has been deleted.', flash[:notice]
  end
  
  test "should get delete_user destroy with bad password" do
    user = users(:with_email)
    @controller.send(:signin, user)
    delete :destroy, { password: 'bad_password' }
    assert_response :success
    assert_template :edit
    
    current_user = assigns(:current_user)
    assert_not_nil current_user
    assert current_user.errors.any?
  end
  
  test "should redirect delete_user destroy to signin" do
    user = users(:with_email)
    delete :destroy, { password: 'bad_password' }
    assert_redirected_to signin_path
  end
end
