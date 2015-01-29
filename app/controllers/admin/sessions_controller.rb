class Admin::SessionsController < Admin::ApplicationController
  def index
    @user = User.admin_get_by_username(params[:user_id])
    @active_sessions = @user.sessions.active.order(:last_activity_at).reverse_order.all
    @inactive_sessions = @user.sessions.inactive.order(:updated_at).reverse_order.all
  end

  def destroy
    user = User.admin_get_by_username(params[:user_id])
    user_session = user.sessions.get_active_session(params[:id])
    if user_session.delete_session
      flash[:notice] = 'Session successfully deleted.'
    else
      flash[:alert] = 'There was a problem deleting the session.'
    end
    redirect_to admin_user_sessions_path(user)
  end
end
