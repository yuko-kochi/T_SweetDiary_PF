class SearchController < ApplicationController

  def search
    # キーワードが入力されていないとトップページに飛ぶ
    redirect_to root_path if params['search']['value'] == ""
    #検索時にパラメーターとして送る値を代入
    # 空白で分割
    @value = params['search']['value']
    #検索時にパラメーターとして送る検索方法を代入
    @how = params['search']['how']
    #検索結果を代入
    @posts = search_for(@how, @value)
    @post_count = @posts.count
  end

end

private
def keyword(value)
  # モデル名.where('カラム名 LIKE(?)','%検索したい文字列%')文字列のどの部分にでも検索したい文字列が含まれていればOK
  # introduction,address 絡むからフリーワード検索
  Post.where('introduction LIKE(?) or address LIKE(?)', "%#{value}%", "%#{value}%")
end

def match_category(value)
  # パラメーターのvalueと同じcategory_idを持つデータを検索
  Post.where(category_id: value)
end

def match_tag(value)
  #PostTagテーブルのpost_idカラムのデータを取得
  Post.where(id: PostTag.select(:post_id)
  .where(tag_id: value) # 重複したpost_idも含め、パラメーターのvalueと同じtag_idを持つデータを検索
  .group(:post_id)) # post_idでグループ化して重複したphoto_idはまとめる
end

  def search_for(how, value)
    #パラメーターのhowによって検索アクションを条件分岐させる
    case how
    when 'match_category'
      match_category(value)
    when 'match_tag'
      match_tag(value)
    else
      keyword(value)
    end
  end