Teudu::Application.routes.draw do
  # See how all your routes lay out with "rake routes"

  resources :categories
  resources :organizations

  resources :users
  
  get "approval/approve"

  get "approval/decline"
  match 'events/my' => 'events#my'
  resources :events

  match 'approval' => 'approval#index'
  match 'about', :to => 'pages#about'

  match 'events/:id/decline' => 'events#decline'
  match 'events/:id/approve' => 'events#approve'

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'events#index'

end
