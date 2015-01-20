class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.sign_in(params[:session])
    if user
      sign_in(user)
      redirect_to root_path
    else
      @error = true
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
