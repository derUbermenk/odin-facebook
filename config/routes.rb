Rails.application.routes.draw do
  devise_for :users
  resources :posts do
    member do
      post 'toggle_like', to: 'posts#toggle_like'
      post 'share', to: 'posts#share'
    end
  end
  resources :comments
  resources :users

  root to: 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
