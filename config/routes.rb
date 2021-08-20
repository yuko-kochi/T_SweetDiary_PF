Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'
  get '/search', to: 'search#search'
  resources :posts do
    resource :likes, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy, :patch]
  end
  resources :tags, only: [:index, :show]
  resources :categorys, only: [:show]
  resources :users,only: [:show,:index,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'calendar', to: 'users#calendar'
  end
  delete 'notifications/destroy_all', to: 'notifications#destroy_all'
  resources :notifications, only: [:index, :destroy]
end