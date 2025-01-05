Rails.application.routes.draw do
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


  resources :bookings, only: [:create, :show, :destroy, :index]
  resources :bookings, only: [:index]
  resources :offres do
    member do
      get 'book', to: 'bookings#new'
    end
  end
  resources :fournisseurs
  resources :users, only: [:index, :show]
  resources :favoris do
    post 'favori', to: 'favoris#create'
    delete 'favori', to: 'favoris#destroy'
  end

  resources :offres do
    post 'favori', to: 'favoris#create'
    delete 'favori', to: 'favoris#destroy'
  end

  get 'pages/lieu', to: 'pages#lieu', as: 'lieu'
  get 'pages/programme', to: 'pages#programme', as: 'programme'
end
