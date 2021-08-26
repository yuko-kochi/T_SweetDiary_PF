require 'rails_helper'

describe '投稿に関するテスト' do
  # FactoryBotのテストデータを使う
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user_id: user.id) }
  
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe "投稿のテスト" do
    before do
      visit new_post_path
    end

    context "投稿が成功したとき" do
      it "投稿成功後の遷移先が正しいか" do
        # contentのフォームにFakerでランダムな５文字の文字列を入れる
        fill_in 'post[introduction]', with: Faker::Lorem.characters(number: 5)
        # 投稿ボタンをクリック
        click_button "登録する"
        # 投稿成功後の遷移先が期待したパスになっているか
        expect(page).to have_current_path posts_path
      end
      it "投稿成功後の表示の確認" do
        # contentのフォームにFakerでランダムな５文字の文字列を入れる
        fill_in 'post[introduction]', with: Faker::Lorem.characters(number: 5)
        # 投稿ボタンをクリック
        click_button "登録する"
        # 投稿が成功して"投稿が成功しました"の文字があるか
        expect(page).to have_content "登録が完了しました"
      end
    end

    context "投稿が失敗したとき" do
      it "投稿失敗後の遷移先が正しいか" do
        # contentのフォームを空にする
        fill_in 'post[introduction]', with: nil
        # 投稿ボタンをクリック
        click_button "登録する"
        # エラーが起きて選先が期待したパスになっているか
        expect(page).to have_current_path posts_path
      end
      it "投稿失敗後の表示の確認" do
        # contentのフォームを空にする
        fill_in 'post[introduction]', with: nil
        # 投稿ボタンをクリック
        click_button "登録する"
        # エラーが出てエラーメッセージが表示されているか
        expect(page).to have_content "入力してください"
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it 'ユーザ画像・名前のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿のintroductionが表示される' do
        expect(page).to have_content post.introduction
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '', href: post_path(post)
      end
    end
    it "削除されるか" do
      # 削除された時データベースから削除されているか
      expect { post.destroy }.to change(Post, :count).by(-1)
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分の投稿と他人の投稿の説明のリンク先がそれぞれ正しい' do
        expect(page).to have_link, href: post_path(post)
        expect(page).to have_link, href: post_path(other_post)
      end
    end
  end
end
