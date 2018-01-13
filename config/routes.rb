Myflix::Application.routes.draw do
  root to: 'pages#front'
  mount StripeEvent::Engine => '/stripe_events'
  
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/home', to: 'videos#index'

  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_token', as: 'register_with_token'
  resources :users, only: [:create, :show]
  resources :categories, only: [:show]

  get '/my_queue', to: 'queue_items#index'
  post '/my_queue/update', to: 'queue_items#update'
  resources :queue_items, only: [:create, :destroy]

  get '/people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :videos, only: [:show] do
    collection do
      get '/search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  get "/forgot_password", to: "forgot_passwords#new"
  get "/confirm_reset", to: "forgot_passwords#confirm_reset"
  resources :forgot_passwords, only: [:create]

  get "/expired_token", to: "pages#expired_token"
  resources :password_resets, only: [:show, :create]

  resources :invitations, only: [:new, :create]

  get 'ui(/:action)', controller: 'ui'
end
