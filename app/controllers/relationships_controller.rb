class RelationshipsController < ApplicationController
  before_action :authenticate_user!

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
    @users = user.followings
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

end