class CategorysController < ApplicationController
  before_action :redirect_to_posts, only: [:show]

  def show
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
    @categorys = Category.find_by(id: params[:id])
    case params[:sort]
    when "likes_count desc"
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @posts = Post.where(category_id: params[:id], status: 0 ).sort {|a,b| b.liked_users.where(created_at: from...to).size <=> a.liked_users.where(created_at: from...to).size}
    when "followings desc"
      @posts = Post.where(category_id: params[:id], status: 0, user_id: [current_user.id, *current_user.following_ids] ).order(created_at: :desc)
    else
      @posts = Post.where(category_id: params[:id], status: 0 ).order(created_at: :desc)
    end
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
  end

  private
  def redirect_to_posts
    @categorys = Category.find_by(id: params[:id])
    if @category.blank?
      redirect_to posts_path
    end
  end
end