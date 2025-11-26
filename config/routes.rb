Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'pages/home'
  get 'home/index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root "pages#home"

  # client chooses to remove booking feature
  # resources :bookings, only: [:create, :show, :destroy, :index]
  resources :offres do
    member do
      get 'book', to: 'bookings#new'
    end
  end
  resources :fournisseurs
  resources :users, only: [:show, :edit, :update, :new]
  resources :favoris do
    post 'favori', to: 'favoris#create'
    delete 'favori', to: 'favoris#destroy'
  end

  resources :offres do
    post 'favori', to: 'favoris#create'
    delete 'favori', to: 'favoris#destroy'
  end

  resources :text_blocks, only: [:update]
  post 'toggle_edit_mode', to: 'application#toggle_edit_mode'

  get 'pages/lieu', to: 'pages#lieu', as: 'lieu'
  get 'pages/payment', to: 'pages#payment', as: 'payment'
  get 'pages/legal', to: 'pages#legal', as: 'legal'
  get 'pages/profile', to: 'pages#profile', as: 'profile'
  get '/le47/festival', to: redirect('/')

end
