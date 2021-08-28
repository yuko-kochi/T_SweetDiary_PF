class TagsController < ApplicationController
  before_action :redirect_to_tags, only: [:show]

  def index
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').pluck(:tag_id))
  end

  def show
    @tag = Tag.find_by(id: params[:id])
    case params[:sort]
    when "likes_count desc"
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @posts = @tag.posts.where(status: 0).includes(:liked_users).sort {|a,b| b.liked_users.where(created_at: from...to).size <=> a.liked_users.where(created_at: from...to).size}
    when "followings desc"
      @posts = @tag.posts.where(user_id: [current_user.id, *current_user.following_ids], status: 0).order(created_at: :desc)
    else
      @posts = @tag.posts.order(created_at: :desc).where(status: 0)
    end
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

  private

  def redirect_to_tags
    @tag = Tag.find_by(id: params[:id])
    if @tag.blank?
      redirect_to tags_path
    end
  end


end