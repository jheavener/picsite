class Admin::ApplicationController < ApplicationController
  protect_from_forgery
  layout 'admin/layouts/application'
  before_filter :admin_required
  
  def admin_required
    @admin_user = User.admin.get_by_username(get_username) if signed_in?
    if !@admin_user
      sign_out
      redirect_to signin_path
    end
  end
end
