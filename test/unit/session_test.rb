require 'test_helper'

class UserSessionTest < ActiveSupport::TestCase
  #
  # self.active
  #
  test "active should return session if active" do
    assert_not_nil UserSession.active.find_by_id(user_sessions(:active).id)
    
    assert_nil UserSession.active.find_by_id(user_sessions(:signed_out).id)
    assert_nil UserSession.active.find_by_id(user_sessions(:expired).id)
    assert_nil UserSession.active.find_by_id(user_sessions(:deleted).id)
  end
  
  #
  # self.inactive
  #
  test "inactive should return session if not active" do
    assert_not_nil UserSession.inactive.find_by_id(user_sessions(:signed_out).id)
    assert_not_nil UserSession.inactive.find_by_id(user_sessions(:expired).id)
    assert_not_nil UserSession.inactive.find_by_id(user_sessions(:deleted).id)
    
    assert_nil UserSession.inactive.find_by_id(user_sessions(:active).id)
  end
  
  #
  # self.get_active_session(id)
  #
  test "active should return session by id if active" do
    assert_not_nil UserSession.get_active_session(user_sessions(:active).id)
    
    assert_nil UserSession.get_active_session(user_sessions(:signed_out).id)
    assert_nil UserSession.get_active_session(user_sessions(:expired).id)
    assert_nil UserSession.get_active_session(user_sessions(:deleted).id)
    
    assert_nil UserSession.get_active_session(99999), 'should not return session if bad id given'
    assert_nil UserSession.get_active_session(''), 'should not return session if blank id given'
    assert_nil UserSession.get_active_session(nil), 'should not return session if nil id given'
  end
  
  #
  # create session
  #
  test "create session" do
    user_session = users(:with_email).sessions.create({ ip_addr: '0.0.0.0', user_agent: 'user_agent_here' })
    assert_not_nil user_session
    assert user_session.errors.empty?
    
    assert_raise(ActiveRecord::StatementInvalid) do
      UserSession.create({ ip_addr: '0.0.0.0', user_agent: 'user_agent_here' })
    end
  end
  
  #
  # self.signout(id)
  #
  test "signout of session" do
    assert UserSession.signout(user_sessions(:active).id)
    assert_nil UserSession.signout(user_sessions(:deleted).id)
  end
  
  #
  # delete_session
  #
  test "delete_session" do
    user_session = user_sessions(:active)
    assert user_session.delete_session
    assert_equal 'deleted', user_session.status
  end
end
