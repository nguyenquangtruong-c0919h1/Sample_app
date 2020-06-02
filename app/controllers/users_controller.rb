class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create,
    :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome_to_the_sample_app"
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    if User.find_by(id: params[:id]).destroy
      flash[:success] = t ".user_detected"
    else
      flash[:danger] = t ".error_detected"
    end
    redirect_to users_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = t "users.edit.update_profile"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.edit.please_login"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
