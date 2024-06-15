Rails.application.routes.draw do
  post 'login', to: 'authentication#login'
  # resources :authentication, only: [:index, :login]
  post 'signup', to: 'users#create'
  resources :projects do
    resources :tasks, only: [:index, :create, :update, :destroy]
    resources :memberships, only: [:index, :create, :update, :destroy]
  end
  resources :users, only: [:index, :show, :create, :update, :destroy]

  # Defines the root path route ("/")
  # root "posts#index"
end
