class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_relationship, only: :destroy

  def create
    if @user = User.find_by(id: params[:followed_id])
      current_user.follow(@user)
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t ".follow_error"
      redirect_to request.referer
    end
  end

  def destroy
    @user = @relationship.followed
    if current_user.unfollow(@user)
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t ".destroy_error"
      redirect_to request.referer
    end
  end

  private

  def load_relationship
    @relationship = Relationship.find_by id: params[:id]
    return if @relationship

    flash[:danger] = t "error.invalid_ID"
    redirect_to request.referer
  end
end
