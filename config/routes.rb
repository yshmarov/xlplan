Rails.application.routes.draw do
  devise_for :users
  root to: 'static_pages#landing_page'
  resources :services
end
