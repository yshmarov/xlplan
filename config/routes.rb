Rails.application.routes.draw do
  resources :clients
  resources :employee_categories
  resources :employees
  devise_for :users, controllers: { invitations: 'invitations'}
  #devise_for :users, controllers: { registrations: "registrations", invitations: 'invitations'}
  #devise_for :users

  resources :people do 
  	member do
  		patch :invite_user
    end
  end
  resources :categories
  resources :machines
  resources :locations
  root to: 'static_pages#landing_page'
  resources :services
end
