Rails.application.routes.draw do
  resources :members
  get 'home/landing_page'
  root :to => "home#landing_page"

  as :user do   
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  devise_for :users, :controllers => { 
    :registrations => "registrations",
    :confirmations => "confirmations",
    :sessions => "milia/sessions", 
    :passwords => "milia/passwords", 
  }

  resources :users, only: [:destroy, :edit, :update]

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
  resources :service_categories, except: [:show, :new, :create]

  resources :locations do
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

  get 'activity', to: 'home#activity'
  get 'dashboard', to: 'home#dashboard'
  get 'calendar', to: 'home#calendar'
  get 'user_roles', to: 'home#user_roles'
  root to: 'home#landing_page'

  #edit tenant plans
  match '/plan/edit' => 'tenants#edit', via: :get, as: :edit_plan
  match '/plan/update' => 'tenants#update', via: [:put, :patch], as: :update_plan

end
