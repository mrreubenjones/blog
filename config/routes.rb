Rails.application.routes.draw do

  root 'posts#index'

  get '/auth/twitter', as: :twitter_signup
  get '/auth/twitter/callback' => 'callbacks#twitter'

  get '/about' => 'home#about'

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :categories, only: [:new, :create, :destroy]
  resources :posts, shallow: true do
    resources :comments, only: [:create, :destroy]
  end


end
