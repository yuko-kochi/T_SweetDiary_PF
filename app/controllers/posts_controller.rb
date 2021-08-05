class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      puts '=========='
      puts @post.address
      puts @post.latitude
      puts @post.longitude
      puts '=========='
      flash[:notice] = "新規投稿が完了しました。"
      redirect_to post_path(@post)
    else
     render :new
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def post_params
    params.require(:post).permit(:image, :introduction, :address, :latitude, :longitude)
  end

end
