class HomesController < ApplicationController
  before_action :set_category_tag, only: [:top]

  def top
    rand = Rails.env.production? ? "RAND()" : "RANDOM()"
    @posts = Post.where(status: 0).order(rand).limit(8)
    @images = Post.where(status: 0).order(rand).limit(4)
  end

end
