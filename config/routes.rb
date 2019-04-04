Rails.application.routes.draw do
  get 'static_pages/landing_page'
  root to: 'static_pages#landing_page'
  get 'stats', to: 'static_pages#stats'
  get 'features', to: 'static_pages#features'
  get 'pricing', to: 'static_pages#pricing'

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
  match '/settings/show' => 'tenants#show', via: :get
  match '/settings/edit' => 'tenants#edit', via: :get, as: :edit_plan
  match '/settings/update' => 'tenants#update', via: [:put, :patch], as: :update_plan

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
    resources :inbound_payments
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

  get 'calendar', to: 'dashboard#calendar'
  get 'activity', to: 'dashboard#activity'
  get 'start', to: 'dashboard#start'

  get 'dashboard/clients'
  get 'dashboard/members'
  get 'dashboard/events'
  get 'dashboard/payments'

  #get 'charts/monthly_events'
  namespace :charts do
    get "monthly_events"
    get "finances_client_due_price_per_month"
    get "members_jobs_per_member_per_month_quantity"
    get "members_confirmed_client_price_per_month"
    get "members_confirmed_earnings_per_month"
    get "payments_per_day"
    get "payments_per_month"
  end
end
