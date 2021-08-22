class HomesController < ApplicationController

  def top
    @posts = Post.where(status: 0).order("RANDOM()").limit(8)
    @images = Post.where(status: 0).order("RANDOM()").limit(4)
  end

end
