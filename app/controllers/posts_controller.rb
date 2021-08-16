class PostsController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    # params[:post][:tag_name]：formから、@postオブジェクトを参照してタグの名前も一緒に送信するコード
    # "ケーキ"　"プリン"　"タルト"のように送られて、取得する
    # split(",")は送信されてきた値を、スペースで区切って配列化する
    tag_list = params[:post][:tag_ids].split(',')
    if @post.save
      # 先ほど取得したタグの配列をsave_tagというインスタンスメソッドを使ってデータベースに保存する処理
      # save_tagインスタンスメソッドの中身はpost.rbで定義
      @post.save_tag(tag_list)
      flash[:notice] = "新規投稿が完了しました。"
      redirect_to post_path(@post)
    else
     render :new
    end
  end

  def index
    if params[:sort] == 'likes_count desc'
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @posts = Post.includes(:liked_users).sort {|a,b| b.liked_users.where(created_at: from...to).size <=> a.liked_users.where(created_at: from...to).size}
    elsif params[:sort] == 'followings desc'
      @posts = Post.where(user_id: [current_user.id, *current_user.following_ids]).order(created_at: :desc)
    else
      @posts = Post.all.order(created_at: :desc)
    end
    @tag_list = Tag.all
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
    @post_count = Post.count
  end

  def show
    @post = Post.find(params[:id])
    @lat = @post.latitude
    @lng = @post.longitude
    gon.lat = @lat
    gon.lng = @lng
    @post_comment = PostComment.new
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
    @lat = @post.latitude
    @lng = @post.longitude
    gon.lat = @lat
    gon.lng = @lng
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_ids].split(',')
    if @post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end


  private
  def post_params
    params.require(:post).permit(:image, :introduction, :category_id, :address, :latitude, :longitude, :start_time)
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path
    end
  end

end
