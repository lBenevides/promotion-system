Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :promotions do
    post 'generate_coupons', on: :member
  end

  resources :product_categories

  resources :coupons, only: [:show] do
    post 'disable', on: :member
    post 'active', on: :member
    match 'search', on: :collection, via: [:get, :post]
  end
end
