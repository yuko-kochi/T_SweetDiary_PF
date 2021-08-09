Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get '/search', to: 'search#search'
  resources :posts do
    resource :likes, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  resources :tags, only: [:index, :show]
end
