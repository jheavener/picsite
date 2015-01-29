module SessionsHelper
  def signed_in?
    get_username
  end
  
  def get_username
    session[:username]
  end
  
  def get_user_session
    session[:user_session]
  end
  
  def get_ip_addr
    request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
  end
  
  def get_user_agent
    request.user_agent
  end
end
