require 'test_helper'

class ForgotpasswordMailerTest < ActionMailer::TestCase
  def setup
    @user = users(:with_token)
  end
  
  test "should send forgotpassword_email" do
    email = ForgotpasswordMailer.forgotpassword_email(@user).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    assert_equal [@user.email], email.to
    assert_equal "Reset your Password Request", email.subject
    #assert_match(/#{resetpassword_path(@user.forgot_password_token)}/, resetpassword_path(@user.forgot_password_token))
  end
end
