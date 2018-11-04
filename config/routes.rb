Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'invitations'}
  #devise_for :users, controllers: { registrations: "registrations", invitations: 'invitations'}
  #devise_for :users

  resources :people
  resources :categories
  resources :machines
  resources :locations
  root to: 'static_pages#landing_page'
  resources :services
end
