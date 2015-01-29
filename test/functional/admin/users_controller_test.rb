require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  def setup
    @admin_user = users(:admin)
  end
  
  test "should get index" do
    assert_routing admin_users_path, { controller: 'admin/users', action: 'index' }
    
    @controller.send(:signin, @admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
  
  test "should get index redirect with non-admin session" do
    user = users(:with_email)
    @controller.send(:signin, user)
    get :index
    assert_redirected_to signin_path
  end
  
  test "should get edit" do
    user = users(:with_email)
    assert_routing edit_admin_user_path(user.to_param), { controller: 'admin/users', action: 'edit', id: user.to_param }
    
    @controller.send(:signin, @admin_user)
    get :edit, { id: user.to_param }
    assert_response :success
    assert_not_nil assigns(:user)
  end
  
  test "should get edit redirect with non-admin session" do
    user = users(:with_email)
    @controller.send(:signin, user)
    get :edit, { id: user.to_param }
    assert_redirected_to signin_path
  end
  
  test "should get update" do
    user = users(:with_email)
    assert_routing({ method: 'put', path: admin_user_path(user.to_param) }, { controller: 'admin/users', action: 'update', id: user.to_param })
    
    @controller.send(:signin, @admin_user)
    put :update, { id: user.to_param, user: { status: 'deleted', email: 'new_email@test.com' } }
    assert_redirected_to edit_admin_user_path(user.to_param)
    assert_not_nil assigns(:user)
  end
  
  test "should get update error" do
    user = users(:with_email)
    
    @controller.send(:signin, @admin_user)
    put :update, { id: user.to_param, user: { status: '', email: 'new_email@test.com' } }
    assert_response :success
    assert_template :edit
    
    user = assigns(:user)
    assert_not_nil user
    assert user.errors.any?
  end
  
  test "should get update redirect with non-admin session" do
    user = users(:with_email)
    
    @controller.send(:signin, user)
    put :update, { id: user.to_param, user: { status: 'deleted', email: 'new_email@test.com' } }
    assert_redirected_to signin_path
  end
end
