Hack::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # queue background web monitor
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["ADMIN"] && password == ENV["ADMIN_PASSWORD"]
  end

  mount Sidekiq::Web => '/sidekiq'

  resources :pages, only: [:index] do
    collection do
      get :welcome, as: 'welcome'
      post :add_airport_form
      post :remove_airport_form
    end
  end

  root 'pages#index'

  get 'auth/:provider/callback', to: 'session#create'
  delete '/signout', to: 'session#destroy', as: 'signout'

  get 'auth/failure', to: redirect('/')

  resources :users, only: [:edit, :update]

  resources :airports, only: [] do
    collection do
      get :autocomplete
      get :geocode
    end
  end

  resources :wishlists, only: [:create, :index] do
    member do
      put :update_sms_state
      post :sms
    end

    collection do
      post :polling_charge
    end
  end

  get "/ical/:token", to: "wishlists#ical", as: :ical
end
