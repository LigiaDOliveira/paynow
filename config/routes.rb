Rails.application.routes.draw do
  root 'home#index'

  resources :payment_methods, only: %i[index show new create edit update]
end
