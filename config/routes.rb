Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get '/search', to: 'search#search'
  resources :posts
  resources :tags, only: [:index, :show]
end
