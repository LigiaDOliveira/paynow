Rails.application.routes.draw do
  root 'home#index'

  resources :payment_methods
end
