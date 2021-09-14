class HomesController < ApplicationController

  def top
    rand = Rails.env.production? ? "RAND()" : "RANDOM()"
    @posts = Post.where(status: 0).order(rand).limit(8)
    @images = Post.where(status: 0).order(rand).limit(4)
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

end
