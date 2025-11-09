Rails.application.routes.draw do

  devise_for :admins, path: 'admin', controllers: {
    sessions: 'admin/admins/sessions'
  }

  namespace :admin do
    root 'users#index'
    resources :users, only: [:index, :show, :destroy]
    resources :comments, only: [:index, :destroy]
  end

  devise_for :users

  get 'about' => 'homes#about', as:'about'
  root to: 'posts#index'

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource  :favorite, only: [:create, :destroy]
  end

  get 'mypage' => 'users#mypage', as:'mypage'
  get "mypage/favorites" => "users#favorites"
  get 'users/following_posts' => 'users#following_posts'
  resources :users, only: [:index, :edit, :show, :update, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'users#followings'
    get 'followers'  => 'users#followers'
  end

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
