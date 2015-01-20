require 'test_helper'

class ResetpasswordControllerTest < ActionController::TestCase
  def setup
    @user = users(:with_token)
  end
  
  test "should get resetpassword" do
    assert_routing resetpassword_path(@user.forgot_password_token), { controller: 'resetpassword', action: 'edit', token: @user.forgot_password_token }
    
    get :edit, token: @user.forgot_password_token
    assert_response :success
    assert_not_nil assigns(:user), "user should not be nil"
  end
  
  #test "should get 404 error with no token" do
  #  get :edit
  #  assert_response 404
  #end
  
  test "should get 404 error with not found token" do
    get :edit, token: '1'
    assert_response 404
  end
  
  test "should register resetpassword" do
    assert_routing({ method: 'put', path: resetpassword_path(@user.forgot_password_token) }, { controller: 'resetpassword', action: 'update', token: @user.forgot_password_token })
    
    put :update, { token: @user.forgot_password_token, user: { password: 'new_password', password_confirmation: 'new_password' } }
    assert_redirected_to signin_path
    assert_not_nil assigns(:user), "user should not be nil"
    assert_equal 'Your password was successfully reset.', flash[:notice]
    assert User.sign_in({ username: @user.display_name, password: 'new_password' })
  end
  
  test "should show resetpassword errors" do
    put :update, { token: @user.forgot_password_token, user: {} }
    assert_response :success
    assert_template :edit
    
    user = assigns(:user)
    assert_not_nil user, "user should not be nil"
    assert user.errors.any?, "user should have errors"
  end
  
  #test "update should get 404 error with no token" do
  #  post :update
  #  assert_response 404
  #end
  
  test "should should get 404 error with not found token" do
    post :update, token: '1'
    assert_response 404
  end
end
