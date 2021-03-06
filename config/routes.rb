Teudu::Application.routes.draw do
  # See how all your routes lay out with "rake routes"

  match 'about',           :to => 'pages#about'
  match 'developer',       :to => 'pages#developer'
  match 'approval'             => 'events#approval'
  match 'events/:id/decline'   => 'events#decline'
  match 'events/:id/approve'   => 'events#approve'
  match 'events/my'            => 'events#my'
  match 'facebook_secret', :to => 'application#facebook_secret'
  match 'google_secret',   :to => 'application#google_secret'

  post 'pages/:branch/deploy' => 'pages#deploy', as: :deploy

  resources :categories
  resources :category_preferences
  resources :events
  resources :organizations
  resources :users


  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'events#index'

end
