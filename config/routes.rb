Rails.application.routes.draw do
  # Keep Devise, Admin, and health check at root level
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  # New site root - placeholder for now
  root to: 'pages#home'

  # Archive: Edition 2025 - All old content
  scope '/edition2025', as: 'edition2025' do
    get '', to: 'pages#old_home', as: 'home'
    get 'pages/home', to: 'pages#old_home'
    get 'home/index', to: 'pages#old_home'

    resources :offres do
      member do
        get 'book', to: 'bookings#new'
      end
      post 'favori', to: 'favoris#create'
      delete 'favori', to: 'favoris#destroy'
    end

    resources :fournisseurs
    resources :users, only: [:show, :edit, :update, :new]
    resources :favoris, only: [:index, :destroy]
    resources :text_blocks, only: [:update]

    post 'toggle_edit_mode', to: 'application#toggle_edit_mode'

    get 'pages/lieu', to: 'pages#lieu', as: 'lieu'
    get 'pages/payment', to: 'pages#payment', as: 'payment'
    get 'pages/legal', to: 'pages#legal', as: 'legal'
    get 'pages/profile', to: 'pages#profile', as: 'profile'
    get 'le47/festival', to: redirect('/edition2025')
  end
end
