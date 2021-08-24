require 'rails_helper'

RSpec.describe 'PostCommentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post_comment.valid? }

    let(:user) { create(:user) }
    let(:post) { create(:post ) }
    let(:post_comment) { build(:post_comment, user_id: user.id, post_id: post.id) }

    context 'commentカラム' do
      it '空欄でないこと' do
        post_comment.comment = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字は×' do
        post_comment.comment = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '200文字以下であること: 201文字は×' do
        post_comment.comment = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end
end