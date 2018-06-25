Rails.application.routes.draw do
  root                     'mapbox#show'
  get 'dashboard'				=> 'mapbox#show'
  get 'sessions/new'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup'  => 'users#new'
  get 'login'   => 'sessions#new'
  post'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy'
  get 'home/show'
  get 'auth/:provider/callback' => 'sessions#callback' #facebook routing
  
  scope :ujs, defaults: {format: :ujs} do
    patch 'room_index_reservation' => 'rooms#index_reservation'
  end
  
  GoogleAuthExample::Application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  resource :home, only: [:show]

  root to: "home#show"
  
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :users
  resources :rooms do
    resources :powers
    resources :messages
    resources :reservations do
      resources :swap_reservations
    end
  end
end
