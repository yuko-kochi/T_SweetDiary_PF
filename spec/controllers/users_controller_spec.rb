require 'rails_helper'

RSpec.describe "Usersコントローラーのテスト", type: :request do
  # FactoryBotのテストデータを使ってuserとpostのデータを作成
  let!(:user) { create(:user) }

  describe "GET /index" do
    it "returns http success" do
      sign_in user
      get users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      sign_in user
      get user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      sign_in user
      get edit_user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /calendar" do
    it "returns http success" do
      sign_in user
      get user_calendar_path(user)
      expect(response).to have_http_status(:success)
    end
  end
end
