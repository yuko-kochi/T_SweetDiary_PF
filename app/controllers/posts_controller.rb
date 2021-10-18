class PostsController < ApplicationController
  before_action :post_set, only: [:show, :edit, :update, :destroy, :ensure_correct_user,:redirect_to_posts, :post_draft]
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]
  before_action :authenticate_user!, only: [:new]
  before_action :redirect_to_posts, only: [:show]
  before_action :post_draft, only: [:show]
  before_action :is_valid_users, only: [:show]
  before_action :set_category_tag

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    # params[:post][:tag_name]：formから、@postオブジェクトを参照してタグの名前も一緒に送信するコード
    # "ケーキ"　"プリン"　"タルト"のように送られて、取得する
    # split(",")は送信されてきた値を、スペースで区切って配列化する
    tag_list = params[:post][:tag_ids].split(/[[:space:]]/)
    if @post.save
      # 先ほど取得したタグの配列をsave_tagというインスタンスメソッドを使ってデータベースに保存する処理
      # save_tagインスタンスメソッドの中身はpost.rbで定義
      @post.save_tag(tag_list)
      flash[:notice] = "登録が完了しました。"
      redirect_to post_path(@post)
    else
     render :new
    end
  end

  def index
    case params[:sort]
    when "likes_count desc"
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @posts = Post.where(status: 0).includes(:liked_users).sort {|a,b| b.liked_users.where(created_at: from...to).size <=> a.liked_users.where(created_at: from...to).size}
    when "followings desc"
      @posts = Post.where(user_id: [current_user.id, *current_user.following_ids], status: 0).order(created_at: :desc)
    else
      @posts = Post.order(created_at: :desc).where(status: 0)
    end
  end

  def show
    @lat = @post.latitude
    @lng = @post.longitude
    gon.lat = @lat
    gon.lng = @lng
    @post_comment = PostComment.new
    @user = @post.user
  end

  def edit
    @lat = @post.latitude
    @lng = @post.longitude
    gon.lat = @lat
    gon.lng = @lng
    @tag_lists = @post.tags.pluck(:name).join(" ")
  end

  def update
    tag_list = params[:post][:tag_ids].split(/[[:space:]]/)
    if @post.update(post_params)
      @post.save_tag(tag_list)
      flash[:notice] = "変更を保存しました。"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private
  def post_params
    params.require(:post).permit(:image, :introduction, :category_id, :address, :latitude, :longitude, :start_time, :status)
  end

  def post_set
    @post = Post.find_by(id: params[:id])
  end


  def ensure_correct_user
    unless @post.user == current_user
      redirect_to posts_path
    end
  end

  def redirect_to_posts
    if @post.blank?
      redirect_to posts_path
    end
  end

  def post_draft
    unless @post.status == "投稿する"
      unless @post.user == current_user
        redirect_to posts_path
      end
    end
  end

  def is_valid_users
    @post = Post.find_by(id: params[:id])
    unless @post.user.is_valid == false
      redirect_to posts_path
    end
  end

end
