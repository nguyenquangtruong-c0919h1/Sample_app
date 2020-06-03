class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_send"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_found"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, t(".not_empty"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t ".password_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  private

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))

    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
