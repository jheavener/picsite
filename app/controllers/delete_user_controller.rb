class DeleteUserController < ApplicationController
  before_filter :signin_required
  
  def edit
  end

  def destroy
    if @user.delete_user(params[:password])
      sign_out
      redirect_to root_path, notice: 'Your account has been deleted.'
    else
      render :edit
    end
  end
end
