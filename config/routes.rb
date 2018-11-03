Rails.application.routes.draw do
  resources :people
  resources :categories
  resources :machines
  resources :locations
  devise_for :users
  root to: 'static_pages#landing_page'
  resources :services
end
