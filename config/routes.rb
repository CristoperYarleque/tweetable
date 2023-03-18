Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: :callbacks }

  root to: "tweets#index"
  resources :tweets
  resources :likes, only: %i[destroy]
  resources :users, only: %i[show]

  namespace :api do
    resources :tweets, only: %i[index show create update destroy]
  end

  namespace :api do
    post "/login" => "sessions#create"
    get "/logout" => "sessions#destroy"
    post "/registration" => "users#create"
  end
end
