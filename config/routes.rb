Rails.application.routes.draw do
  resources :members
  get 'home/landing_page'
  root :to => "home#landing_page"

  devise_for :users, :controllers => { 
    :registrations => "milia/registrations",
    :confirmations => "milia/confirmations",
    :sessions => "milia/sessions", 
    :passwords => "milia/passwords", 
  }


end
