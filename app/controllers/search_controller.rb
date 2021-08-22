class SearchController < ApplicationController

  def search
    @keyword = params[:keyword]
    @posts = Post.search_for(@keyword).order(created_at: :desc).where(status: 0)
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end
end