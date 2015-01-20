module SessionsHelper
  def signed_in?
    get_username
  end
  
  def get_username
    session[:display_name]
  end
end
