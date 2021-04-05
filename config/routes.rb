Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :promotions do
    member do
      post 'generate_coupons'
      post 'approve'
    end
    get 'search', on: :collection
    
  end

  resources :product_categories

  resources :coupons, only: [:show] do
    member do
      post 'disable'
      post 'active'
    end
    get 'search', on: :collection
  end
end
