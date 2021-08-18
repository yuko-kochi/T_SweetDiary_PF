class User < ApplicationRecord

 validates :name, presence: true, length: { in: 2..15 }, uniqueness: true
 devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :introduction, length: { maximum: 100 }
  attachment :profile_image

  # dependent: :destroy 親モデルを削除する際に、その親モデルに紐づく「子モデル」も一緒に削除できる
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :post_comments, dependent: :destroy

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  # 被フォロー関係を通じて参照→自分をフォローしている人
  # through（スルー）は、あるリレーションを他のテーブルを通して実現する際に用いる
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

  # 紐付ける名前とクラス名が異なるため、明示的にクラス名とIDを指定して紐付け
  # active_notifications：自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # passive_notifications：相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # -----------------フォロー機能------------------
  def follow(user_id)
    # createメソッドはnewとsaveを合わせた挙動
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    # relationshipsテーブルには対応するレコードはただ一つ
    # そのためfind_byによって1レコードを特定し、destroyメソッドで削除する
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    # include?は対象の配列に引数のものが含まれていればtrue、含まれていなければfalseを返す
    followings.include?(user)
  end
  # ------------------------------------------------

  # --------------------通知機能--------------------
  def create_notification_follow(current_user)
    notification = Notification.find_by(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if notification.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
  # ------------------------------------------------


end
