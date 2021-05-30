Rails.application.routes.draw do


  devise_for :users
  resources :microposts
  resources :users, only: [:show]
  resources :relationships, only: [:create, :destroy]

  resources :users do
    member do
      get :following, :followers
    end
  end

  get 'home/index'
  root 'home#index'

end
