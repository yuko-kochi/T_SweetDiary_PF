class LikesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    like = current_user.likes.new(post_id: params[:post_id])
    like.save
    #通知の作成
     @post.create_notification_by(current_user)
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post_id: params[:post_id])
    like.destroy
  end

end