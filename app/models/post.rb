class Post < ApplicationRecord

  belongs_to :user
  attachment :image
  # addressカラムを基準に緯度経度を算出する。
  geocoded_by :address
  # 住所変更時に緯度経度も変更する。
  after_validation :geocode, if: :address_changed?

end
