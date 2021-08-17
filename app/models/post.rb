class Post < ApplicationRecord

  validates :image, presence: true
  validates :introduction, presence: true, length: { in: 2..300 }
  validates :category_id, presence: true
  validates :start_time, presence: true

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

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  #ジャンルの選択が「--」の時は保存できないようにする
  validates :category_id, numericality: { other_than: 1 }

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :post_comments, dependent: :destroy

  has_many :notifications, dependent: :destroy

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  # --------------------タグ機能-------------------
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
  # ------------------------------------------------

  # --------------------通知機能-------------------
  def create_notification_by(current_user)
    # すでに「いいね」されているか検索
  temp = Notification.find_by(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
      notification.save if notification.valid?
    end

  end


  def create_notification_comment(current_user, post_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, post_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment(current_user, post_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, post_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
   end
   # ------------------------------------------------

end