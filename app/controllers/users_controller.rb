class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :edit]
  before_action :calendar_correct_user, only: [:calendar]
  before_action :redirect_to_users, only: [:show]

  def show
    @user = User.find_by(id: params[:id])
    case params[:sort]
    when "likes_count desc"
      @posts = @user.posts.where(status: 0).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    when "draft desc"
      @posts = @user.posts.where(status: 1)
    when "like_post desc"
      likes = Like.where(user_id: current_user.id).pluck(:post_id)
      @posts = Post.find(likes)
    else
      @posts = @user.posts.order(created_at: :desc).where(status: 0)
    end
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

  def index
    @users = User.all
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

  def edit
    @user = User.find(params[:id])
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "変更を保存しました。"
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end

  def calendar
    @user = User.find(params[:user_id])
    @posts = @user.posts
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def calendar_correct_user
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def redirect_to_users
    @user = User.find_by(id: params[:id])
    if @user.blank?
      redirect_to users_path
    end
  end

end