Rails.application.routes.draw do
  resources :expences
  get 'static_pages/landing_page'
  root to: 'static_pages#landing_page'
  #pages before logging in
  get 'features', to: 'static_pages#features'
  get 'pricing', to: 'static_pages#pricing'
  get 'about', to: 'static_pages#about'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  get 'security', to: 'static_pages#security'
  #total stats for the superadmin
  get 'stats', to: 'static_pages#stats'

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
  match '/settings/edit' => 'tenants#edit', via: :get, as: :edit_tenant
  match '/settings/update' => 'tenants#update', via: [:put, :patch], as: :update_tenant
  match '/plan/edit' => 'tenants#edit_plan', via: :get, as: :edit_plan

  get "/contacts/:provider/contacts_callback" => "clients#index"
  get "/contacts/failure" => "clients#failure"
  #match "/contacts/:importer/callback" => "your_controller#callback"

  resources :clients do
    get :debtors, on: :collection
    collection do
      match 'search' => 'clients#search', via: [:get, :post], as: :search
    end
    resources :comments
  end

  resources :service_categories
  resources :services

  resources :locations

  resources :events do
    resources :inbound_payments, except: [:edit, :update]
    get :close, :tomorrow, on: :collection
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

  resources :inbound_payments, except: [:edit, :update]
  resources :expences

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
    get "events_per_day"
  end
end
