class HomesController < ApplicationController

  def top
    @posts = Post.where(status: 0).order("RANDOM()").limit(8)
  end

end
