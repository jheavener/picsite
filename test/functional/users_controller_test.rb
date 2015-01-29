require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @valid_params = { username: "TestUser", email: "testuser@localhost.com", password: "password", password_confirmation: "password" }
  end
  
  test "should show new" do
    assert_routing join_path, { controller: 'users', action: 'new' }
    
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should create user" do
    assert_routing({ method: 'post', path: join_path }, { controller: 'users', action: 'create' })
    
    assert_difference('User.count') do
      post :create, user: @valid_params
    end
    assert_not_nil assigns(:user)
    assert assigns(:user).valid?
    assert @controller.signed_in?
    assert_redirected_to root_path
    assert_equal 'Thank You for joining PicSite.', flash[:notice]
  end
  
  test "should show create error" do
    post :create
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:user)
    assert assigns(:user).invalid?
  end
  
  test "should show user page" do
    user = users(:with_email)
    assert_routing user_path(user.display_name), { controller: 'users', action: 'show', id: user.display_name }
    
    get :show, id: user.display_name
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:user)
  end
  
  test "show should get 404 error with user not found" do
    get :show, id: '1'
    assert_response 404
  end
  
  test "should show user settings page" do
    user = users(:with_email)
    assert_routing settings_path, { controller: 'users', action: 'edit' }
    
    @controller.send(:signin, user)
    get :edit
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:current_user)
  end
  
  test "should redirect from user settings page if not signed_in" do
    get :edit
    assert_redirected_to signin_path
  end
  
  test "should redirect from user settings page if session user is not found" do
    user = users(:with_email)
    get :edit, nil, { display_name: user.display_name+'1' }
    assert_redirected_to signin_path
  end
  
  test "should update user settings" do
    user = users(:with_email)
    assert_routing({ method: 'put', path: settings_path }, { controller: 'users', action: 'update' })
    
    new_email = 'new_email@test.com'
    @controller.send(:signin, user)
    put :update, { password: 'password', user: { email: new_email } }
    assert_response :success
    assert_template :edit
    
    current_user = assigns(:current_user)
    assert_not_nil current_user
    assert current_user.errors.empty?
    assert_equal new_email, current_user.email 
  end
  
  test "should show update user settings errors with nil email" do
    user = users(:with_email)
    @controller.send(:signin, user)
    put :update, { password: 'password', user: {} }
    assert_response :success
    assert_template :edit
    
    user = assigns(:current_user)
    assert_not_nil user
    assert user.errors.any? 
  end
  
  test "should redirect update user settings page if not signed_in" do
    user = users(:with_email)
    put :update, { user: { email: 'new_email@test.com' } }
    assert_redirected_to signin_path
  end
  
  test "should redirect form update user settings page if user is not found" do
    user = users(:with_email)
    put :update, { user: { email: 'new_email@test.com' } }, { display_name: user.display_name+'1' }
    assert_redirected_to signin_path
  end
end
