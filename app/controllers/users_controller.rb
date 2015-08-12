class UsersController < ApplicationController
  before_action :require_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = user.id
      flash['notice'] = "Profile was successfully created. You're now logged in."
      redirect_to root_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash['notice'] = "Your profile was successfully updated."
      redirect_to root_path
    else
      render :edit
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end