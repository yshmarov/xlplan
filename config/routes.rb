Rails.application.routes.draw do
  #get 'comments/index'
  #get 'comments/new'
  devise_for :users, controllers: { invitations: 'invitations'}
  #devise_for :users, controllers: { registrations: "registrations", invitations: 'invitations'}
  resources :users, only: [:destroy, :edit, :update]
  #devise_for :users

  resources :employees do 
    resources :skills, only: [:new, :create, :destroy]
  	member do
  		patch :invite_user
    end
  end

  resources :clients do
    resources :comments
  end

  resources :services
  resources :service_categories, except: [:show]

  resources :locations do
    resources :workplaces
  end
  resources :workplaces, only: [:show]

  resources :jobs do
    resources :comments
    get :mark_attendance, on: :collection
  	member do
  		patch :mark_planned
  		patch :mark_confirmed
  		patch :mark_confirmed_by_client
  		patch :mark_not_attended
  		patch :mark_rejected_by_us
  		patch :mark_cancelled_by_client
    end

  end

  get 'stats/general'
  get 'stats/clients'
  get 'stats/employees'
  get 'stats/jobs'
  get 'stats/services'
  get 'stats/locations'

  get 'activity', to: 'static_pages#activity'
  get 'dashboard', to: 'static_pages#dashboard'
  get 'calendar', to: 'static_pages#calendar'
  get 'user_roles', to: 'static_pages#user_roles'
  root to: 'static_pages#landing_page'
end
