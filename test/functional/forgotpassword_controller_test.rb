require 'test_helper'

class ForgotpasswordControllerTest < ActionController::TestCase
  test "should get forgotpassword form" do
    assert_routing forgotpassword_path, { controller: 'forgotpassword', action: 'edit' }
    
    get :edit
    assert_response :success
    assert_not_nil assigns(:user)
  end
  
  test "should register forgotpassword" do
    assert_routing({ method: 'post', path: forgotpassword_path }, { controller: 'forgotpassword', action: 'update' })
    assert_routing({ method: 'put', path: forgotpassword_path }, { controller: 'forgotpassword', action: 'update' })
    
    user = users(:with_email)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :update, user: { username: user.display_name }
    end
    assert_response :success
    assert_template :edit
    
    user = assigns(:user)
    assert_not_nil user, "user should not be nil"
    assert user.errors.empty?, "user should have no errors"
    assert !user.forgot_password_token.blank?, "user's forgot_password_token should be populated"
    assert !user.forgot_password_at.blank?, "user's forgot_password_at should be populated"
    assert_not_nil assigns(:message), "message should not be nil"
  end
  
  test "should fail forgotpassword with user not found" do
    post :update, user: { username: 'UserNotFound' }
    assert_response :success
    assert_template :edit
    
    user = assigns(:user)
    assert_not_nil user, "user should not be nil"
    assert user.errors[:username].any?, "username should have errors"
    assert user.forgot_password_token.blank?, "user's forgot_password_token should be blank"
    assert user.forgot_password_at.blank?, "user's forgot_password_at should be blank"
    assert_not_nil !assigns(:message), "message should be nil"
  end
  
  test "should fail forgotpassword with no email linked to user" do
    user = users(:without_email)
    post :update, user: { username: user.display_name }
    assert_response :success
    assert_template :edit
    
    user = assigns(:user)
    assert_not_nil user, "user should not be nil"
    assert user.errors[:base].any?, "user base should have errors"
    assert user.forgot_password_token.blank?, "user's forgot_password_token should be blank"
    assert user.forgot_password_at.blank?, "user's forgot_password_at should be blank"
    assert_not_nil !assigns(:message), "message should be nil"
  end
end
