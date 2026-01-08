Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'pages/home'
  get 'home/index'
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root "pages#home"

  # Dashboard for users to see their registered workshops
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

  # 2025 edition routes (archived version)
  namespace :archive_2025, path: '2025' do
    root to: 'pages#home', as: ''
    get 'lieu', to: 'pages#lieu'
    resources :offres, only: [:index, :show]
    resources :fournisseurs, only: [:index, :show]
  end

  # client chooses to remove booking feature
  # resources :bookings, only: [:create, :show, :destroy, :index]
  resources :offres do
    member do
      get 'book', to: 'bookings#new'
      post 'register', to: 'offres#register'
      delete 'unregister', to: 'offres#unregister'
    end
    post 'favori', to: 'favoris#create'
    delete 'favori', to: 'favoris#destroy'
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
