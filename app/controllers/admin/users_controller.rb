class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.all
  end
  
  def edit
    @user = User.admin_get_by_username(params[:id])
  end
  
  def update
    @user = User.admin_get_by_username(params[:id])
    if @user.update_attributes(params[:user], as: :admin)
      redirect_to edit_admin_user_path(@user), notice: 'Update Successful.'
    else
      render :edit
    end
  end
end
