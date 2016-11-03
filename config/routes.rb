Rails.application.routes.draw do

  root 'posts#index'
  get '/about' => 'home#about'

  resources :posts

end
