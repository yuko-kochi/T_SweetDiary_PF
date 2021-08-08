class PostsController < ApplicationController
  before_action :authenticate_user!

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
      puts '=========='
      puts @post.address
      puts @post.latitude
      puts @post.longitude
      puts '=========='
      # 先ほど取得したタグの配列をsave_tagというインスタンスメソッドを使ってデータベースに保存する処理
      # save_tagインスタンスメソッドの中身はpost.rbで定義
      @post.save_tag(tag_list)
      puts '=========='
      puts @post.tags
      puts '=========='
      flash[:notice] = "新規投稿が完了しました。"
      redirect_to post_path(@post)
    else
     render :new
    end
  end

  def index
    @posts = Post.all
    @tag_list = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @lat = @post.latitude
    @lng = @post.longitude
    gon.lat = @lat
    gon.lng = @lng
    puts '=========='
    puts gon.lat
    puts gon.lng
    puts '=========='
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
    params.require(:post).permit(:image, :introduction, :category_id, :address, :latitude, :longitude)
  end

end
