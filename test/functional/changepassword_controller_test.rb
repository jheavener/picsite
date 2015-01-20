require 'test_helper'

class ChangepasswordControllerTest < ActionController::TestCase
  test "should get changepassword edit page" do
    assert_routing changepassword_path, { controller: 'changepassword', action: 'edit' }
    
    user = users(:with_email)
    get :edit, nil, { display_name: user.display_name }
    assert_response :success
    assert_not_nil assigns(:user)
  end
  
  test "should redirect from changepassword edit if not signed_in" do
    get :edit
    assert_redirected_to signin_path
  end
  
  test "should redirect from changepassword edit if session user is not found" do
    user = users(:with_email)
    get :edit, nil, { display_name: user.display_name+'1' }
    assert_redirected_to signin_path
  end

  test "should get changepassword update page" do
    user = users(:with_email)
    assert_routing({ method: 'put', path: changepassword_path }, { controller: 'changepassword', action: 'update' })
    
    new_password = 'new_password'
    put :update, { password: 'password', user: { password: new_password, password_confirmation: new_password } }, { display_name: user.display_name }
    assert_redirected_to settings_path
    assert_equal 'Your password was successfully changed.', flash[:notice]
    
    user = assigns(:user)
    assert_not_nil user
    assert user.errors.empty?
    assert user.authenticate(new_password) 
  end
  
  test "should get changepassword errors with nil params" do
    user = users(:with_email)
    
    put :update, nil, { display_name: user.display_name }
    assert_response :success
    assert_template :edit
    
    user = assigns(:user)
    assert_not_nil user
    assert user.errors.any? 
  end
  
  test "should redirect from changepassword update if not signed_in" do
    get :edit
    assert_redirected_to signin_path
  end
  
  test "should redirect from changepassword update if session user is not found" do
    user = users(:with_email)
    get :edit, nil, { display_name: user.display_name+'1' }
    assert_redirected_to signin_path
  end
end
