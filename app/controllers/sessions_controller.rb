class SessionsController < ApplicationController
  before_filter :signin_required, only: [:index, :destroy]
  
  def index
    @user_sessions = @current_user.sessions.active.order(:last_activity_at).reverse_order.all
  end
  
  def new
  end

  def create
    user = User.signin(params[:session])
    if user
      signin(user)
      redirect_to root_path
    else
      @error = true
      render :new
    end
  end

  def update
    signout
    redirect_to root_path
  end
  
  def destroy
    user_session = @current_user.sessions.get_active_session(params[:id])
    if user_session.delete_session
      flash[:notice] = 'Session successfully deleted.'
    else
      flash[:alert] = 'There was a problem deleting the session.'
    end
    redirect_to user_sessions_path
  end
end
