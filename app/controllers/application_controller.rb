class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error 404
  end
  
  protected
  
  include SessionsHelper
  
  def signin(user)
    signout
    user_session = user.sessions.create({ ip_addr: get_ip_addr, user_agent: get_user_agent })
    session[:username]     = user.to_param
    session[:user_session] = user_session.to_param
  end
  
  def signout
    UserSession.signout(get_user_session) if get_user_session
    reset_session
  end
  
  def signin_required
    @current_user = User.get_by_username(get_username) if signed_in?
    user_session = @current_user.sessions.get_active_session(get_user_session) if @current_user && get_user_session
    if user_session
      user_session.touch(:last_activity_at)
    else
      signout
      redirect_to signin_path, notice: "Please Sign In to continue."
    end
  end

  def render_error(status)
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/#{status.to_s()}", :status => status, :layout => false }
      format.all { render :nothing => true, :status => status }
    end
  end
end
