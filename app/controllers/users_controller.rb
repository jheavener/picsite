class UsersController < ApplicationController
  before_filter :signin_required, only: [:edit, :update, :destroy]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user], as: :join)
    if @user.save
      sign_in(@user)
      redirect_to root_path, notice: 'Thank You for joining PicSite.'
    else
      render :new
    end
  end
  
  def show
    @user = User.get_by_username(params[:id])
    render_error(404) and return if !@user
  end
  
  def edit
  end
  
  def update
    @user.change_email(params[:password], params[:user])
    render :edit
  end
end
