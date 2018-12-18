Rails.application.routes.draw do
  get 'home/landing_page'
  root to: 'home#landing_page'

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
  resources :members do
  	member do
  		patch :invite_user
    end
  end

  #edit tenant info
  match '/organization/edit' => 'tenants#edit', via: :get, as: :edit_plan
  match '/organization/update' => 'tenants#update', via: [:put, :patch], as: :update_plan

  resources :clients do
    resources :comments
  end

  resources :services

  #to edit names and delete empty ones
  resources :service_categories, except: [:show, :new, :create]

  resources :locations

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

  get 'calendar', to: 'home#calendar'
  get 'activity', to: 'home#activity'
  get 'dashboard', to: 'home#dashboard'

  get 'stats/finances'
  get 'stats/clients'
  get 'stats/members'
  get 'stats/jobs'
  get 'stats/services'
  get 'stats/locations'

end
