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
  match '/organization/show' => 'tenants#show', via: :get
  match '/organization/edit' => 'tenants#edit', via: :get, as: :edit_plan
  match '/organization/update' => 'tenants#update', via: [:put, :patch], as: :update_plan

  resources :clients do
    collection do
      match 'search' => 'clients#search', via: [:get, :post], as: :search
    end
    resources :comments
  end

  resources :services
  resources :service_categories, only: [:edit, :update, :create]

  resources :locations

  resources :appointments do
    get :checkout, on: :collection
  	member do
  		patch :mark_planned
  		patch :mark_confirmed
  		patch :mark_member_cancelled
  		patch :mark_client_cancelled
  		patch :mark_client_not_attended
    end
  end
  #for public_activity
  resources :jobs, only: :show

  get 'calendar', to: 'home#calendar'
  get 'activity', to: 'home#activity'
  #get 'start', to: 'home#start'

  get 'stats/finances'
  get 'stats/clients'
  get 'stats/members'
  get 'stats/appointments'
  get 'stats/services'
  get 'stats/locations'

end
