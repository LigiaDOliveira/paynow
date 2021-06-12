Rails.application.routes.draw do
  devise_for :staffs
  devise_for :admins_paynow
  root 'home#index'

  resources :payment_methods
  resources :companies
end
