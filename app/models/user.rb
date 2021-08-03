class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # dependent: :destroy 親モデルを削除する際に、その親モデルに紐づく「子モデル」も一緒に削除できる
  has_many :posts, dependent: :destroy
end
