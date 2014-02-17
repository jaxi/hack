Hack::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  get "pages/index"
  root 'pages#index'

  get 'auth/:provider/callback', to: 'session#create'
  delete 'signout', to: 'session#destroy', as: 'signout'
  get '/session/edit/:id', to: 'session#edit', as: 'edit_user'
  put '/session/:id', to: 'session#update', as: 'update_user'

  get 'auth/failure', to: redirect('/')
end
