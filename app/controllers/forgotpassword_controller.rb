class ForgotpasswordController < ApplicationController
  def edit
    @user = User.new
  end

  def update
    @user = User.forgot_password(params[:user])
    if @user.errors.empty?
      ForgotpasswordMailer.forgotpassword_email(@user).deliver
      @message = 'An Email has been sent to reset the password.'
    end
    render :edit
  end
end
