Rails.application.routes.draw do
  get 'home/landing_page'
  root to: 'home#landing_page'

  # *MUST* come *BEFORE* devise's definitions (below)
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
  resources :members

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

  resources :service_categories, only: [:edit, :update, :create]
  resources :services

  resources :locations

  resources :events do
    get :close, on: :collection
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

  resources :inbound_payments

  get 'calendar', to: 'home#calendar'
  get 'my_calendar', to: 'home#my_calendar'
  get 'activity', to: 'home#activity'
  #get 'start', to: 'home#start'

  get 'stats/finances'
  get 'stats/clients'
  get 'stats/members'
  get 'stats/events'

  #get 'charts/monthly_events'
  namespace :charts do
    get "monthly_events"
    get "finances_client_due_price_per_month"
    get "members_jobs_per_member_per_month_quantity"
    get "members_confirmed_client_price_per_month"
    get "members_confirmed_earnings_per_month"
  end
end
