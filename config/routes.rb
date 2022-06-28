Rails.application.routes.draw do
   devise_for :users, controllers: {
    registrations: 'users/registrations'
   } 
  root 'orders#index'
  resources :orders do
    collection { post :check }
  end
  resources :users do
    collection { get :select }
  end
  resources :products
  resources :carts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/my_cart' => 'carts#my_cart'
  post '/add_item' => 'carts#add_item'
  post '/update_item' => 'carts#update_item'
  delete '/delete_item' => 'carts#delete_item'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
