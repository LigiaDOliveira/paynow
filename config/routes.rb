Rails.application.routes.draw do
  devise_for :staffs
  devise_for :admins_paynow
  root 'home#index'

  resources :companies do
    get 'my_staff', on: :member
    post 'reset_token'
    put 'request_suspension', on: :member
  end
  namespace :company do
    resources :products, only: %i[index show new create edit update destroy]
  end
  resources :payment_methods
  namespace :staff do
    put 'block_staff'
    resources :payment_methods, only: %i[index show] do
      resources :boletos, only: %i[new create edit update destroy]
      resources :pixes, only: %i[new create edit update destroy]
      resources :credit_cards, only: %i[new create edit update destroy]
    end
  end
end
