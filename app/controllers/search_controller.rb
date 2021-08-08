class SearchController < ApplicationController

  def search
    if params[:content].nil?
      @category = params["search"]["category"]
      @posts = Post.search_category_for(@category)
      @post_count = Post.search_category_for(@category).count
    else
      @content=params[:content]
      @posts = Post.search_for(@content)
      @post_count = Post.search_for(@content).count
    end
  end

end
