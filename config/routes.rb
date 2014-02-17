Hack::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  get "pages/index"
  root 'pages#index'

  get 'auth/:provider/callback', to: 'session#create'
  get 'auth/failure', to: redirect('/')
  delete 'signout', to: 'session#destroy', as: 'signout'
end
