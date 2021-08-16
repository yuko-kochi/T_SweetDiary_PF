class TagsController < ApplicationController

  def index
    @tag_list = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts
    @tag_list = Tag.all.order(rank_point: :desc)
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end
end
