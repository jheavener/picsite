class DeleteUserController < ApplicationController
  before_filter :signin_required
  
  def edit
  end

  def destroy
    if @current_user.delete_user(params[:password])
      signout
      redirect_to root_path, notice: 'Your account has been deleted.'
    else
      render :edit
    end
  end
end
