class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  include SessionsHelper
  
  def sign_in(user)
    sign_out
    session[:display_name] = user.display_name
  end
  
  def sign_out
    reset_session
    #session[:display_name] = nil
  end
  
  def signin_required
    @user = User.get_by_username(get_username) if signed_in?
    if !@user
      sign_out
      redirect_to signin_path
    end
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error 404
  end

  def render_error(status)
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/#{status.to_s()}", :status => status, :layout => false }
      format.all { render :nothing => true, :status => status }
    end
  end
end
