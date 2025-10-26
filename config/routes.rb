Rails.application.routes.draw do
  devise_for :users
  root to: 'conversations#index'

  resources :users, only: [:index]

  resources :conversations, only: [:index, :show] do
    resources :messages, only: [:create]
  end
end