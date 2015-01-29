require 'test_helper'

class ChangepasswordControllerTest < ActionController::TestCase
  test "should get changepassword edit page" do
    assert_routing changepassword_path, { controller: 'changepassword', action: 'edit' }
    
    user = users(:with_email)
    @controller.send(:signin, user)
    get :edit
    assert_response :success
    assert_not_nil assigns(:current_user)
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
    @controller.send(:signin, user)
    put :update, { password: 'password', user: { password: new_password, password_confirmation: new_password } }
    assert_redirected_to settings_path
    assert_equal 'Your password was successfully changed.', flash[:notice]
    
    current_user = assigns(:current_user)
    assert_not_nil current_user
    assert current_user.errors.empty?
    assert current_user.authenticate(new_password) 
  end
  
  test "should get changepassword errors with nil params" do
    user = users(:with_email)
    
    @controller.send(:signin, user)
    put :update
    assert_response :success
    assert_template :edit
    
    current_user = assigns(:current_user)
    assert_not_nil current_user
    assert current_user.errors.any?
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
