Hack::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  get "pages/index"
  root 'pages#index'
end
