class Category < ActiveHash::Base

  include ActiveHash::Associations
  has_many :posts

  self.data = [
   { id: 1, name: '--' },
   { id: 2, name: 'ケーキ' },
   { id: 3, name: 'チョコレート' },
   { id: 4, name: 'クッキー・焼き菓子' },
   { id: 5, name: 'アイス・ジェラート' },
   { id: 6, name: 'プリン・ゼリー' },
   { id: 7, name: 'パンケーキ' },
   { id: 8, name: 'シュー・パイ' },
   { id: 9, name: '洋菓子その他' },
   { id: 10, name: '和菓子' }
 ]
end
