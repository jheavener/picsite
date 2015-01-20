require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @valid_params = { username: "TestUser", email: "testuser@localhost.com", password: "password", password_confirmation: "password" }
  end
  
  #
  # to_param
  #
  test "to_param should return display_name" do
    user = users(:with_email)
    assert_equal user.display_name, user.to_param
  end
  
  #
  # self.active
  #
  test "active should return user if active" do
    assert_not_nil User.active.find_by_username(users(:with_email).username)
    assert_not_nil User.active.find_by_username(users(:admin).username)
    
    assert_nil User.active.find_by_username(users(:deleted).username)
    assert_nil User.active.find_by_username(users(:banned).username)
  end
  
  #
  # self.get_by_username
  #
  test "get_by_username should return user if found and active" do
    # valid
    assert_not_nil User.get_by_username(users(:with_email).to_param), 'should return active user'
    assert_not_nil User.get_by_username(users(:admin).to_param), 'should return admin user'
    
    # invalid user status
    assert_nil User.get_by_username(users(:deleted).to_param), 'should not return deleted user'
    assert_nil User.get_by_username(users(:banned).to_param), 'should not return banned user'
    
    # invalid info.
    assert_nil User.get_by_username('bad'), 'should not return user if bad username given'
    assert_nil User.get_by_username(''), 'should not return user if blank username given'
    assert_nil User.get_by_username(nil), 'should not return user if nil username given'
  end
  
  #
  # self.admin_get_by_username
  #
  test "admin_get_by_username should return user" do
    # valid
    assert_not_nil User.admin_get_by_username(users(:with_email).to_param), 'should return active user'
    assert_not_nil User.admin_get_by_username(users(:admin).to_param), 'should return admin user'
    assert_not_nil User.admin_get_by_username(users(:deleted).to_param), 'should return deleted user'
    assert_not_nil User.admin_get_by_username(users(:banned).to_param), 'should return banned user'
    
    # invalid info.
    assert_nil User.admin_get_by_username('bad'), 'should not return user if bad username given'
    assert_nil User.admin_get_by_username(''), 'should not return user if blank username given'
    assert_nil User.admin_get_by_username(nil), 'should not return user if nil username given'
  end
  
  #
  # self.get_by_token
  #
  test "get_by_token should return user if found and active" do
    # valid
    assert_not_nil User.get_by_token(users(:with_token).forgot_password_token), 'should return active user'
    
    # invalid user status
    assert_nil User.get_by_token(users(:deleted_with_token).forgot_password_token), 'should not return deleted user'
    assert_nil User.get_by_token(users(:banned_with_token).forgot_password_token), 'should not return banned user'
    
    # invalid info.
    assert_nil User.get_by_token('bad'), 'should not return user if bad token given'
    assert_nil User.get_by_token(''), 'should not return user if blank token given'
    assert_nil User.get_by_token(nil), 'should not return user if nil token given'
  end
  
  #
  # join
  #
  test "join should save user with valid params" do
    user = User.new(@valid_params, as: :join)
    assert user.save
  end
  
  test "join should be invalid with blank params" do
    user = User.new
    assert !user.save
  end
  
  test "join username should be present" do
    user = User.new(@valid_params.merge({ username: "" }), as: :join)
    assert !user.save
  end
  
  test "join username should not be under min length" do
    user = User.new(@valid_params.merge({ username: "aa" }), as: :join)
    assert !user.save
  end
  
  test "join username should not exceed max length" do
    user = User.new(@valid_params.merge({ username: "a" * 31 }), as: :join)
    assert !user.save
  end
  
  test "join username should be in valid format" do
    bad_usernames = ['test!', 'test 2', 'Test/3', '@test4']
    bad_usernames.each do |username|
      user = User.new(@valid_params.merge({ username: username }), as: :join)
      assert !user.save, "username format should be invalid: #{username}"
    end
  end
  
  test "join username should be unique case insensitive" do
    user = User.new(@valid_params.merge({ username: users(:with_email).username.upcase }), as: :join)
    assert !user.save
  end
  
  test "join email should be optional" do
    user = User.new(@valid_params.merge({ email: "" }), as: :join)
    assert user.save
  end
  
  test "join email should not exceed max length" do
    user = User.new(@valid_params.merge({ email: "a" * 101 }), as: :join)
    assert !user.save
  end
  
  test "join email should be in valid format" do
    bad_emails = ['email', 'email@host,com', 'email.com', 'email@host.', 'email@host_e.com', 'email@host+e.com']
    bad_emails.each do |email|
      user = User.new(@valid_params.merge({ email: email }), as: :join)
      assert !user.save, "email format should be invalid: #{email}"
    end
  end
  
  test "join password should be present" do
    user = User.new(@valid_params.merge({ password: "", password_confirmation: "" }), as: :join)
    assert !user.save
  end
  
  test "join password should not be under min length" do
    user = User.new(@valid_params.merge({ password: "a" * 5, password_confirmation: "a" * 5 }), as: :join)
    assert !user.save
  end
  
  test "join password confirmation should match password" do
    user = User.new(@valid_params.merge({ password: "password2" }), as: :join)
    assert !user.save
  end
  
  #
  # change_email
  #
  test "change_email should be valid with new email" do
    user = users(:with_email)
    new_email = 'new_email@test.com'
    assert user.change_email('password', { email: new_email })
    assert user.errors.empty?
    assert_equal new_email, user.email
  end
  
  test "change_email should be valid with blank optional email" do
    user = users(:with_email)
    assert user.change_email('password', { email: '' })
    assert user.errors.empty?
    assert_equal '', user.email
  end
  
  test "change_email should be invalid with bad email" do
    user = users(:with_email)
    assert !user.change_email('password', { email: 'new_email' })
    assert user.errors[:email].any?
  end
  
  test "change_email should be invalid with nil email" do
    user = users(:with_email)
    assert !user.change_email('password', {})
    assert user.errors[:base].any?
    assert_equal users(:with_email).email, user.email
    assert_equal ['Error updating email'], user.errors[:base]
  end
  
  test "change_email should be invalid with bad password" do
    user = users(:with_email)
    new_email = 'new_email@test.com'
    assert !user.change_email('bad_password', { email: new_email })
    assert user.errors[:base].any?
    assert_equal ['Password is incorrect'], user.errors[:base]
    assert_equal new_email, user.email
  end
  
  #
  # change_password
  #
  test "change_password should be valid with new email" do
    user = users(:with_email)
    new_password = 'new_password'
    assert user.change_password('password', { password: new_password, password_confirmation: new_password })
    assert user.errors.empty?
    assert user.authenticate(new_password)
  end
  
  test "change_password should be invalid with bad current password" do
    user = users(:with_email)
    new_password = 'new_password'
    assert !user.change_password('bad_password', { password: new_password, password_confirmation: new_password })
    assert user.errors[:base].any?
    assert_equal ['Password is incorrect'], user.errors[:base]
    assert !user.authenticate(new_password)
  end
  
  test "change_password should be invalid with bad new password" do
    user = users(:with_email)
    new_password = 'bad'
    assert !user.change_password('password', { password: new_password, password_confirmation: new_password })
    assert user.errors[:password].any?, 'Password should have errors'
  end
  
  test "change_password should be invalid with bad new password confirmation" do
    user = users(:with_email)
    new_password = 'new_password'
    assert !user.change_password('password', { password: new_password, password_confirmation: new_password+'1' })
    assert user.errors[:password].any?, 'Password should have errors'
  end
  
  #
  # delete_user
  #
  test "delete_user should be valid" do
    user = users(:with_email)
    assert user.delete_user('password'), 'valid delete_user should return true'
    assert user.errors.empty?, 'valid delete_user should have no errors'
    assert_equal 'deleted', user.status, 'valid delete_user should have status deleted'
  end
  
  test "delete_user should be invalid with bad current password" do
    user = users(:with_email)
    assert !user.delete_user('bad_password')
    assert user.errors[:base].any?
    assert_equal ['Password is incorrect'], user.errors[:base]
  end
  
  #
  # sign_in
  #
  test "sign_in should be valid" do
    user = users(:with_email)
    assert_not_nil User.sign_in({ username: user.display_name, password: 'password' })
  end
  
  test "sign_in should be invalid with blank username" do
    user = users(:with_email)
    assert_nil User.sign_in({ username: '', password: 'password' })
  end
  
  test "sign_in should be invalid with not found username" do
    user = users(:with_email)
    assert_nil User.sign_in({ username: user.display_name+'1', password: 'passworde' })
  end
  
  test "sign_in should be invalid with blank password" do
    user = users(:with_email)
    assert_nil User.sign_in({ username: user.display_name, password: '' })
  end
  
  test "sign_in should be invalid with wrong password" do
    user = users(:with_email)
    assert_nil User.sign_in({ username: user.display_name, password: 'password1' })
  end
  
  test "sign_in should be invalid with deleted user" do
    user = users(:deleted)
    assert_nil User.sign_in({ username: user.display_name, password: 'password' })
  end
  
  test "sign_in should be invalid with banned user" do
    user = users(:banned)
    assert_nil User.sign_in({ username: user.display_name, password: 'password' })
  end
  
  #
  # forgot_password
  #
  test "forgot_password should be valid" do
    user = users(:with_email)
    user = User.forgot_password({ username: user.display_name })
    assert user.errors.empty?
    assert !user.forgot_password_token.blank?
  end
  
  #test "forgot_password should be invalid with nil params" do
  #  user = users(:with_email)
  #  assert User.forgot_password().errors[:username].any?
  #end
  
  test "forgot_password should be invalid with blank username" do
    user = users(:with_email)
    assert User.forgot_password({ username: '' }).errors[:username].any?
  end
  
  test "forgot_password should be invalid with not found username" do
    user = users(:with_email)
    assert User.forgot_password({ username: user.display_name+'1' }).errors[:username].any?
  end
  
  test "forgot_password should be invalid with no email linked to username" do
    user = users(:without_email)
    assert User.forgot_password({ username: user.display_name }).errors[:base].any?
  end
  
  #
  # reset_password
  #
  test "reset_password should be valid" do
    user = users(:with_token)
    user = User.reset_password(user.forgot_password_token, { password: 'new_password', password_confirmation: 'new_password' })
    assert user.errors.empty?
    assert user.forgot_password_token.blank?
    assert User.sign_in({ username: user.username, password: 'new_password' })
  end
  
  test "reset_password should be invalid with invalid token" do
    user = users(:with_token)
    assert !User.reset_password(user.forgot_password_token+'1', { password: 'new_password', password_confirmation: 'new_password' })
  end
  
  #test "reset_password should be invalid with nil params" do
  #  user = users(:with_token)
  #  user = User.reset_password(user.forgot_password_token)
  #  assert user.errors.any?, 'Should have errors'
  #end
  
  test "reset_password should be invalid with blank password" do
    user = users(:with_token)
    user = User.reset_password(user.forgot_password_token, { password: '', password_confirmation: '' })
    assert user.errors.any?, 'Should have errors'
  end
  
  test "reset_password should be invalid with bad password" do
    user = users(:with_token)
    user = User.reset_password(user.forgot_password_token, { password: '123', password_confirmation: '123' })
    assert user.errors.any?, 'Should have errors'
  end
  
  test "reset_password should be invalid with bad password confirmation" do
    user = users(:with_token)
    user = User.reset_password(user.forgot_password_token, { password: 'new_password', password_confirmation: 'new_password2' })
    assert user.errors.any?, 'Should have errors'
  end
  
  test "reset_password should be invalid with deleted user" do
    user = users(:deleted_with_token)
    assert_nil User.reset_password(user.forgot_password_token, { password: 'new_password', password_confirmation: 'new_password' })
  end
  
  test "reset_password should be invalid with banned user" do
    user = users(:banned_with_token)
    assert_nil User.reset_password(user.forgot_password_token, { password: 'new_password', password_confirmation: 'new_password' })
  end
end
