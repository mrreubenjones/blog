Rails.application.routes.draw do

  root 'posts#index'
  get '/about' => 'home#about'

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :posts, shallow: true do
    resources :comments, only: [:create, :destroy]
  end

end
