Rails.application.routes.draw do
  get 'users/show'
  devise_for :users 
  root to: 'homes#top'
  get '/search', to: 'search#search'
  resources :posts do
    resource :likes, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  
  resources :tags, only: [:index, :show]
  
  resources :users,only: [:show,:index,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers' 
  end
  
end
