Rails.application.routes.draw do
  #devise_for :users
  resources :posts do
    member do
      post 'toggle_like', to: 'posts#toggle_like'
      post 'share', to: 'posts#share'
    end
  end
  resources :comments

  get 'profile', to: 'users#show'
  resources :users

  resources :user_connections do
    collection do
      post 'add/:user_id', to: 'user_connections#create', as: :add
    end

    member do
      put '/', to: 'user_connections#update', as: :accept
      delete '/delete', to: 'user_connections#destroy', as: :delete
    end
  end

  root to: 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
