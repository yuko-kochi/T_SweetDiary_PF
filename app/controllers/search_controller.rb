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
    @tag_list = Tag.all.order(rank_point: :desc)
    @category = Category.find([2, 3, 4, 5, 6,7,8,9,10])
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


def search_for(how, value)
  #パラメーターのhowによって検索アクションを条件分岐させる
  case how
  when 'match_category'
    match_category(value)
  else
    keyword(value)
  end
end