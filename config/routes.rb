Teudu::Application.routes.draw do
  # See how all your routes lay out with "rake routes"

  match 'about',          :to => 'pages#about'
  match 'developer',      :to => 'pages#developer'
  match 'approval'            => 'events#approval'
  match 'events/:id/decline'  => 'events#decline'
  match 'events/:id/approve'  => 'events#approve'
  match 'events/my'           => 'events#my'

  post 'deploy/:branch' => 'pages#deploy', as: :deploy

  resources :categories
  resources :events
  resources :organizations
  resources :users


  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'events#index'

end
