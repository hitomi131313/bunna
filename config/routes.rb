Rails.application.routes.draw do

  devise_for :users

  get 'about' => 'homes#about', as:'about'
  root to: 'posts#index'

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource  :favorite, only: [:create, :destroy]
  end

  get 'mypage' => 'users#mypage', as:'mypage'
  resources :users, only: [:index, :edit, :show, :update, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
