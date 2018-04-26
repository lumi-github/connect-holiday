class RelationshipsController < ApplicationController

  before_action :require_user_logged_in
  before_action :set_user

  user = nil

  def follow
    current_user.follow(@user)
    flash[:success] = 'ユーザをフォローしました。'
    redirect_to profile_path(@user.id)
  end

  def unfollow
    current_user.unfollow(@user)
    flash[:success] = 'ユーザのフォローを解除しました。'
    redirect_to profile_path(@user.id)
  end

  def block
    current_user.block(@user)
    flash[:success] = 'ユーザをブロックしました。'
    redirect_to profile_path(@user.id)
  end

  def unblock
    current_user.unblock(@user)
    flash[:success] = 'ユーザのブロックを解除しました。'
    redirect_to profile_path(@user.id)
  end

  private

  def set_user
    @user = User.find(params[:user_id])

    unless @user
      redirect_to root_url
    end
  end

end
