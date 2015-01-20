class ForgotpasswordMailer < ActionMailer::Base
  default from: "PicSite <noreply@startsampling.com>"
  
  def forgotpassword_email(user)
    @user = user
    mail(to: @user.email, subject: 'Reset your Password Request')
  end
end
