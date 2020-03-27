Rails.application.routes.draw do
  constraints subdomain: 'app' do
    get 'static_pages/landing_page'
  end
  #get 'static_pages/pricing', constraints: {subdomain: 'admin'}
  #get 'pricing', to: 'static_pages#pricing', constraints: {subdomain: 'admin'}
  constraints subdomain: "api" do
    scope module: "api" do
      get 'static_pages/features'
    end
  end
  #get 'cars', to: 'cars#index'
  #post 'cars', to: 'cars#create'
  #get 'cars/new', to: 'cars#new', as: :new_car
  #get 'cars/:id/edit', to: 'cars#edit', as: :edit_car
  #get 'cars/:id', to: 'cars#show', as: :car
  #put 'cars/:id', to: 'cars#update'
  #patch 'cars/:id', to: 'cars#update'
  #delete 'cars/:id', to: 'cars#destroy'
  #post 'leads/create', to: 'leads#create', as: :create_a_lead

  get 'static_pages/landing_page'
  root to: 'static_pages#landing_page'
  get 'stats', to: 'static_pages#stats' #total stats for the superadmin

  get 'booking', to: 'booking#index'
  get '/booking/:id', to: 'booking#show', as: :booking_show
  match '/booking/:id' => 'booking#create', via: [:post], as: :create
  get '/booking/:id/new', to: 'booking#new', as: :new_booking

  # *MUST* come *BEFORE* devise's definitions (below)
  as :user do   
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  devise_for :users, :controllers => { 
    registrations: 'registrations',
    confirmations: 'confirmations',
    sessions: 'milia/sessions', 
    passwords: 'milia/passwords', 
    invitations: 'invitations'
  }

  resources :users, only: [:destroy, :edit, :update]
  resources :members do
    get :calendar_list, on: :collection
    member do
      delete :delete_avatar
      get :calendar
  		patch :invite_user
    end
  end
  resources :after_signup_wizard

  resources :leads do
    resources :booking_wizard, controller: 'leads/booking_wizard'
    member do
      patch :create_client_from_lead
    end
  end

  #edit tenant info
  match '/settings/show' => 'tenants#show', via: :get
  match '/settings/edit' => 'tenants#edit', via: :get, as: :edit_tenant
  match '/settings/update' => 'tenants#update', via: [:put, :patch], as: :update_tenant
  match '/plan/edit' => 'tenants#edit_plan', via: :get, as: :edit_plan

  #contacts google import
  get 'contacts/import'
  get 'contacts/add_all'
  get '/contacts/:provider/contact_callback' => 'contacts#import'
  get '/contacts/failure' => 'contacts#failure'
  resources :contacts, except: [:destroy, :create, :new, :edit, :update] do
    member do
      patch :create_client_from_contact, :fill_missing_client_data
    end
  end

  resources :clients do
    get :debtors, :no_gender, :bday_today, :no_events, :untagged, on: :collection
    resources :comments
  end

  resources :service_categories
  resources :services

  resources :locations
  resources :workplaces, only: [:show, :index, :destroy]

  resources :events do
    resources :transactions, except: [:edit, :update]
    get :close, :today, :tomorrow, on: :collection
  	member do
  		patch :mark_planned
  		patch :mark_confirmed
  		patch :mark_member_cancelled
  		patch :mark_client_cancelled
  		patch :mark_no_show
  		patch :mark_no_show_refunded
  		patch :send_email_to_client
  		patch :send_email_to_members
    end
  end

  resources :transactions, except: [:edit, :update]
  resources :cash_accounts, except: [:show]

  get 'calendar', to: 'dashboard#calendar'
  get 'activity', to: 'dashboard#activity'

  get 'dashboard/client_stats'
  get 'dashboard/member_stats'
  get 'dashboard/event_stats'
  get 'dashboard/transaction_stats'
  get 'dashboard/lead_stats'
  get 'dashboard/member_salary'
  namespace :charts do
    get 'monthly_events'
    get 'finances_client_due_price_per_month'
    get 'members_jobs_per_member_per_month_quantity'
    get 'members_confirmed_client_price_per_month'
    get 'members_confirmed_earnings_per_month'
    get 'transactions_per_day'
    get 'transactions_per_month'
    get 'events_per_day'
  end
end