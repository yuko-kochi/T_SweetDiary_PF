class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = current_user.post.new(post_params)
    if @post.save
      flash[:notice] = "新規投稿が完了しました。"
      redirect_to post_path(@post)
    else
     render :new
    end
  end

  def index
  end

  def show
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
