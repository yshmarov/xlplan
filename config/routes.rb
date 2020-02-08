Rails.application.routes.draw do
  get 'static_pages/landing_page'
  root to: 'static_pages#landing_page'
  get 'features', to: 'static_pages#features'
  get 'pricing', to: 'static_pages#pricing'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  get 'stats', to: 'static_pages#stats' #total stats for the superadmin

  get 'booking', to: 'booking#index'
  get '/booking/:id', to: 'booking#show', as: :booking_show
  match '/booking/:id' => 'booking#create_booking', via: [:post], as: :create_booking
  get '/booking/:id/new', to: 'booking#new', as: :new_booking

  # *MUST* come *BEFORE* devise's definitions (below)
  as :user do   
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  devise_for :users, :controllers => { 
    :registrations => 'registrations',
    :confirmations => 'confirmations',
    :sessions => 'milia/sessions', 
    :passwords => 'milia/passwords', 
  }

  resources :users, only: [:destroy, :edit, :update]
  resources :members do
    member do
      delete :delete_avatar
      get :calendar
    end
  end

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

  get 'contacts/index'
  get 'contacts/list'
  get 'contacts/add_all'
  get '/contacts/:provider/contact_callback' => 'contacts#index'
  get '/contacts/failure' => 'contacts#failure'
  resources :contacts, except: [:index, :destroy, :create, :new, :edit, :update] do
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
  get 'start', to: 'dashboard#start'

  get 'dashboard/client_stats'
  get 'dashboard/member_stats'
  get 'dashboard/event_stats'
  get 'dashboard/transaction_stats'
  get 'dashboard/lead_stats'
  get 'dashboard/member_salary'

  #get 'charts/monthly_events'
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