Rails.application.routes.draw do
  devise_for :staffs
  devise_for :admins_paynow
  root 'home#index'

  resources :payment_methods
  resources :companies do
    post 'reset_token'
  end
  namespace :company do
    resources :products, only: %i[index show new create edit update destroy]
  end
  namespace :staff do
    resources :payment_methods, only: %i[index show] do
      resources :boletos, only: %i[new create edit update destroy]
      resources :pixes, only: %i[new create edit update destroy]
      resources :credit_cards, only: %i[new create edit update destroy]
    end
  end

end
