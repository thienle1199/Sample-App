class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy correct_user following followers]
  before_action :logged_in_user, only: %i[edit update index destroy following followers]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy
  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 10)
  end

  def show
    redirect_to(root_url) && return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'You account has been successfully updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:warning] = 'User deleted'
    redirect_to users_path
  end

  def following
    @title = 'Following'
    @users = @user.following.paginate(page: params[:page], per_page: 10)
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @users = @user.followers.paginate(page: params[:page], per_page: 10)
    render 'show_follow'
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

def correct_user
  redirect_to root_url unless current_user?(@user)
end

def admin_user
  redirect_to root_url unless current_user.admin?
end
