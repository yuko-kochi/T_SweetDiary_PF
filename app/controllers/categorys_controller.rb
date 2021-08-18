class CategorysController < ApplicationController

  def show
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
    @categorys = Category.find(params[:id])
    if params[:sort] == 'likes_count desc'
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @posts = Post.where(category_id: params[:id], status: 0 ).sort {|a,b| b.liked_users.where(created_at: from...to).size <=> a.liked_users.where(created_at: from...to).size}
    elsif params[:sort] == 'followings desc'
      @posts = Post.where(category_id: params[:id], status: 0, user_id: [current_user.id, *current_user.following_ids] ).order(created_at: :desc)
    else
      @posts = Post.where(category_id: params[:id], status: 0 ).order(created_at: :desc)
    end
    @tag_list = Tag.all
  end
end