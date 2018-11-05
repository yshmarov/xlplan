Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'invitations'}
  #devise_for :users, controllers: { registrations: "registrations", invitations: 'invitations'}
  #devise_for :users

  resources :people do 
  	member do
  		patch :invite_user
    end
  end
  resources :clients
  resources :employees

  resources :categories
  resources :services
  resources :employee_categories
  resources :locations
  resources :machines
  resources :events
  get 'calendar', to: 'static_pages#calendar'
  root to: 'static_pages#landing_page'
end
