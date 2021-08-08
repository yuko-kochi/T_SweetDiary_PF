Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get '/posts/category', to: "posts#category"
  resources :posts
  resources :tags, only: [:index, :show]
end
