Rails.application.routes.draw do
  devise_for :admin_paynows
  root 'home#index'

  resources :payment_methods
end
