Hack::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :pages, only: [:index] do
    collection do
      get :welcome, as: 'welcome'
      post :add_airport_form
      post :remove_airport_form
    end
  end

  root 'pages#index'

  get 'auth/:provider/callback', to: 'session#create'
  delete 'signout', to: 'session#destroy', as: 'signout'

  get 'auth/failure', to: redirect('/')

  resources :users, only: [:edit, :update]

  resources :airports, only: [] do
    collection do
      get :autocomplete
    end
  end
end
