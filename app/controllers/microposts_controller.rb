class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = t ".save_success"
    else
      flash[:danger] = t ".save_fail"
    end
    redirect_to root_url
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".destroy_success"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = t ".destroy_fail"
      redirect_to root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    if @micropost.nil?
      flash[:danger] = t ".correct_nil"
      redirect_to root_url
    end
  end
end
