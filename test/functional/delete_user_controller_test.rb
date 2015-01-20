require 'test_helper'

class DeleteUserControllerTest < ActionController::TestCase
  test "should get delete_user edit" do
    assert_routing delete_user_path, { controller: 'delete_user', action: 'edit' }
    
    user = users(:with_email)
    get :edit, nil, { display_name: user.display_name }
    assert_response :success
    assert_not_nil assigns(:user)
  end
  
  test "should redirect delete_user edit to signin" do
    user = users(:with_email)
    get :edit
    assert_redirected_to signin_path
  end
  
  test "should redirect successful delete_user destroy" do
    user = users(:with_email)
    assert_routing({ method: 'delete', path: delete_user_path }, { controller: 'delete_user', action: 'destroy' })
    
    delete :destroy, { password: 'password' }, { display_name: user.display_name }
    assert_redirected_to root_path
    assert_equal 'Your account has been deleted.', flash[:notice]
  end
  
  test "should get delete_user destroy with bad password" do
    user = users(:with_email)
    delete :destroy, { password: 'bad_password' }, { display_name: user.display_name }
    assert_response :success
    assert_template :edit
    
    user = assigns(:user)
    assert_not_nil user
    assert user.errors.any?
  end
  
  test "should redirect delete_user destroy to signin" do
    user = users(:with_email)
    delete :destroy, { password: 'bad_password' }
    assert_redirected_to signin_path
  end
end
