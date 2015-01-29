require 'test_helper'

class Admin::HomepageControllerTest < ActionController::TestCase
  def setup
    @admin_user = users(:admin)
  end
  
  test "should get index" do
    assert_routing admin_root_path, { controller: 'admin/homepage', action: 'index' }
    
    @controller.send(:signin, @admin_user)
    get :index
    assert_response :success
  end
  
  test "should get index redirect with nil session" do
    assert_routing admin_root_path, { controller: 'admin/homepage', action: 'index' }
    
    get :index
    assert_redirected_to signin_path
  end
  
  test "should get index redirect with non-admin session" do
    assert_routing admin_root_path, { controller: 'admin/homepage', action: 'index' }
    
    user = users(:with_email)
    @controller.send(:signin, user)
    get :index
    assert_redirected_to signin_path
  end
end
