class Post < ApplicationRecord

  belongs_to :user
  attachment :image
  # addressカラムを基準に緯度経度を算出する。
  geocoded_by :address
  # 住所変更時に緯度経度も変更する。
  after_validation :geocode, if: :address_changed?

  # 中間テーブルにdependent: :destroyオプションを付けることで、Postが削除されると同時にPostとTagの関係が削除される
  has_many :post_tags, dependent: :destroy
  # throughオプションを使う場合、先にその中間テーブルとの関連付けを行う
  # throughオプションによってpost_tagsテーブルを通してtagsテーブルとの関連付けを行う
  # これを行うことで、Post.tagsとすればPostに紐付けられたTagの取得が可能になる
  has_many :tags, through: :post_tags

  def save_tag(sent_tags)
    # self.メソッド名は
    # createアクションにて保存した@postに紐付いているタグが存在する場合、「タグの名前を配列として」全て取得
    # pluckは、1つのモデルで使用されているテーブルからカラム (1つでも複数でも可) を取得するクエリを送信するのに使用できる
    # 今回ではtagsテーブルからtag_nameカラムを取得するクエリを送信
    # selectと異なり、pluckはデータベースから受け取った結果を直接Rubyの配列に変換してくれる
    # unless~は、「タグが存在しているか」を確認
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得した@postに存在するタグから、送信されてきたタグを除いたタグをold_tagsする
    # 文字列の配列でも下記のように引き算できる。
    # a = ["first", "second", "third"]　 b = ["first", "third", "forth"]
    # a - b => ["second"]　 b - a => ["forth"]
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    # 古いタグを削除する
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    # 新しいタグを追加しデータベースに保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

end
