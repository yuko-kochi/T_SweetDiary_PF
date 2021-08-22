class HomesController < ApplicationController

  def top
    @posts = Post.where(status: 0).order("RAND()").limit(8)
    @images = Post.where(status: 0).order("RAND()").limit(4)
  end

end
