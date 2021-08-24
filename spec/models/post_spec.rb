require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let(:post) { build(:post, user_id: user.id) }

    context 'introductionカラム' do
      it '空欄でないこと' do
        post.introduction = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字は×' do
        post.introduction = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '300文字以下であること: 301文字は×' do
        post.introduction = Faker::Lorem.characters(number: 301)
        is_expected.to eq false
      end
    end

    context 'imageカラム' do
      it '空欄でないこと' do
        post.image = ''
        is_expected.to eq false
      end
    end

    context 'category_id' do
      it '空欄でないこと' do
        post.category_id = ''
        is_expected.to eq false
      end
    end

    context 'start_time' do
      it '空欄でないこと' do
        post.start_time = ''
        is_expected.to eq false
      end
    end

  end
end