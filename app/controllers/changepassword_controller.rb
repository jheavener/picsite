class ChangepasswordController < ApplicationController
  before_filter :signin_required
  
  def edit
  end

  def update
    if @current_user.change_password(params[:password], params[:user])
      redirect_to settings_path, notice: 'Your password was successfully changed.'
    else
      render :edit
    end
  end
end
