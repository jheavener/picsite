class ResetpasswordController < ApplicationController
  def edit
    @user = User.get_by_token(params[:token])
    render_error(404) and return if !@user
  end

  def update
    @user = User.reset_password(params[:token], params[:user])
    render_error(404) and return if !@user
    if @user.errors.empty?
      redirect_to signin_path, notice: 'Your password was successfully reset.'
    else
      render :edit
    end
  end
end
