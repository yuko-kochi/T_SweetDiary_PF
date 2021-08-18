class TagsController < ApplicationController

  def index
    @tag_list = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
    if params[:sort] == 'likes_count desc'
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @posts = @tag.posts.where(status: 0).includes(:liked_users).sort {|a,b| b.liked_users.where(created_at: from...to).size <=> a.liked_users.where(created_at: from...to).size}
    elsif params[:sort] == 'followings desc'
      @posts = @tag.posts.where(user_id: [current_user.id, *current_user.following_ids], status: 0).order(created_at: :desc)
    else
      @posts = @tag.posts.order(created_at: :desc).where(status: 0)
    end
    @tag_list = Tag.all
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

end