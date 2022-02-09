Rails.application.routes.draw do
  devise_for :users
  resources :posts do
    member do
      post 'toggle_like', to: 'posts#toggle_like'
    end
  end
  resources :comments 

  root to: 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
