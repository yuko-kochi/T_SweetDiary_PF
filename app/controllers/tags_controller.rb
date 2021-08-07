class TagsController < ApplicationController

  def index
    @tag_list = Tag.all
  end

  def show
   @tag = Tag.find(params[:id])
  end
end
