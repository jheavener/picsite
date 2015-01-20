require 'test_helper'

class HomepageControllerTest < ActionController::TestCase
  test "should get index" do
    assert_routing root_path, { controller: 'homepage', action: 'index' }
    
    get :index
    assert_response :success
  end
end
