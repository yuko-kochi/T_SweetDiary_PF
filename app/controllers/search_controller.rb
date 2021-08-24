class SearchController < ApplicationController

  def search
    # キーワードが入力されていないとトップページに飛ぶ
    redirect_to root_path if params[:keyword] == ""
    @keyword = params[:keyword]
    # 投稿検索結果
    @posts = search_post(@keyword).order(created_at: :desc).where(status: 0)
    # タグ検索結果
    @tags = search_tag(@keyword).order(created_at: :desc).where(status: 0)
    # ユーザー検索結果
    @users = search_user(@keyword)
    @tag_list = Tag.find( PostTag.group(:tag_id).order('count(tag_id)desc').limit(10).pluck(:tag_id))
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
  end

  private
  # 投稿検索
  def search_post(keyword)
    Post.where(['introduction LIKE(?) or address LIKE(?)', "%#{keyword}%","%#{keyword}%"])
  end

  # タグ検索
  def search_tag(keyword)
    tag_id = Tag.where('name LIKE(?)', "%#{keyword}%").pluck(:id)
    # タグのpost_id取得
    post_tag_id = PostTag.where(tag_id: tag_id).pluck(:post_id)
    # 投稿を検索！
    Post.where(id: post_tag_id)
    # Tag.where('name LIKE ?', "%#{keyword}%")
  end

  # ユーザー検索
  def search_user(keyword)
    User.where(['name LIKE(?)', "%#{keyword}%"])
  end

end