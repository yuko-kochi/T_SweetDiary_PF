require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    context 'introductionカラム' do
      it '空欄でないこと' do
        post.introduction = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字は×' do
        post.introduction = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字は〇' do
        post.introduction = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '300文字以下であること: 300文字は〇' do
        post.introduction = Faker::Lorem.characters(number: 300)
        is_expected.to eq true
      end
      it '300文字以下であること: 301文字は×' do
        post.introduction = Faker::Lorem.characters(number: 301)
        is_expected.to eq false
      end
    end

  end
end