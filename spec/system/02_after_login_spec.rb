require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認' do
      subject { current_path }

      it '投稿一覧を押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[1].native.inner_text
        posts_link = posts_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_link
        is_expected.to eq '/posts'
      end
      it 'ユーザー一覧を押すと、ユーザ一覧画面に遷移する' do
        users_link = find_all('a')[2].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users'
      end
      it 'ユーザー一覧を押すと、ユーザ一覧画面に遷移する' do
        posts_new_link = find_all('a')[3].native.inner_text
        posts_new_link = posts_new_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_new_link
        is_expected.to eq '/posts/new'
      end
      it 'マイページを押すと、ユーザー詳細画面に遷移する' do
        users_link = find_all('a')[4].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it '通知を押すと、通知画面に遷移する' do
        notifications_link = find_all('a')[5].native.inner_text
        notifications_link = notifications_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link notifications_link
        is_expected.to eq '/notifications'
      end
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

  describe '投稿一覧画面のテスト' do
    before do
      visit new_post_path
    end

    context '投稿成功のテスト' do
      it '自分の新しい投稿が正しく保存される' do
        fill_in 'post[introduction]', with: Faker::Lorem.characters(number: 40)
        expect { click_button '登録する' }.to change(user.posts, :count).by(1)
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
        expect(page).to have_content "登録が完了しました"
      end
    end

    context "投稿が失敗したとき" do
      it "投稿失敗後の遷移先が正しいか" do
        fill_in 'post[introduction]', with: nil
        click_button "登録する"
        expect(page).to have_current_path posts_path
      end
      it "投稿失敗後の表示の確認" do
        fill_in 'post[introduction]', with: nil
        click_button "登録する"
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
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it '「Sweet Post」と表示される' do
        expect(page).to have_content 'Sweet Post'
      end
      it 'opinion編集フォームが表示される' do
        expect(page).to have_field 'post[introduction]', with: post.introduction
      end
      it '変更を保存ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分と他人のリンクがそれぞれ表示される' do
        expect(page).to have_link, href: user_path(user)
        expect(page).to have_link, href: user_path(other_user)
      end
    end
  end


  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧に自分の投稿のリンクが正しい' do
        expect(page).to have_link, href: post_path(post)
      end
      it '投稿一覧に自分の名前が表示される' do
        expect(page).to have_content user.name
      end
      it '投稿一覧に自分の紹介が表示される' do
        expect(page).to have_content user.introduction
      end
      it '投稿一覧に編集リンクが表示される' do
        expect(page).to have_link, href: edit_user_path(user)
      end
      it '投稿一覧にカレンダーリンクが表示される' do
        expect(page).to have_link, href: user_calendar_path(user)
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: post_path(other_post)
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it 'Update Userボタンが表示される' do
        expect(page).to have_button '登録する'
      end
    end
  end
end