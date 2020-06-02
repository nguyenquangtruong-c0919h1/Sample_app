class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create,
    :show]
  before_action :load_user, except: [:new, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] =  t "thanh_cong"
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_detected"
    else
      flash[:danger] = t ".error_detected"
    end
    redirect_to users_url
  end

  def edit; end

  def index
    @users = User.paginate page: params[:page]
  end

  def update
    if @user.update user_params
      flash[:success] = t "users.edit.update_profile"
      redirect_to @user
    else
      render :edit
    end
  end

  def following
    @title = t ".following"
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = t ".followers"
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error.invalid_ID"
    redirect_to root_url
  end
end
