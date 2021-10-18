class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category_tag, only: [:followings, :followers]

  # ——————フォロー機能を作成・保存・削除する——————
  def create
    current_user.follow(params[:user_id])
    @user = User.find(params[:user_id])
    @user.create_notification_follow(current_user)
  end

  def destroy
    current_user.unfollow(params[:user_id])
    @user = User.find(params[:user_id])
  end

  #————————フォロー・フォロワー一覧を表示する——————
  def followings
    user = User.find(params[:user_id])
    @users = user.followings.where(is_valid: false)
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers.where(is_valid: false)
  end

end