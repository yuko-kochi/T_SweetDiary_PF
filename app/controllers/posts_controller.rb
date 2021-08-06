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
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
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
    params.require(:post).permit(:image, :introduction, :address, :latitude, :longitude)
  end

end
