class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit,:update, :destroy, :correct_user]
  before_action :logged_in_user,only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def index
    @users = User.paginate(page: params[:page])
  end
  def show; end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
      flash[:success] = "Welcome #{@user.name} to the Sample Apple"
      redirect_to @user
    else
  		render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = "You account has been successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy 
    flash[:warning] = "User deleted"
    redirect_to users_path
  end
end

private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)	
	end

  # set the coresponding user to @user
  def set_user
    @user = User.find(params[:id])
  end
  #Confirm a logged in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to login_path
    end
  end

  def correct_user
      redirect_to root_url unless current_user?(@user)
  end

  def admin_user
     redirect_to root_url unless current_user.admin?
  end