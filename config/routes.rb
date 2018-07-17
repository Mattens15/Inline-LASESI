Rails.application.routes.draw do
  root                     'mapbox#show'
  get 'dashboard'				=> 'mapbox#show'
  get 'sessions/new'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'signup'  => 'users#new'
  get 'login'   => 'sessions#new'
  post'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy'
  get 'auth/:provider/callback' => 'sessions#callback'
  get '/redirect', to: 'calendars#redirect', as: 'redirect'
  get '/callback', to: 'calendars#callback', as: 'callback'
  put 'destroy_avatar' => 'rooms#destroy_avatar'

  resources :sessions, only: [:create, :destroy]
  resource :home, only: [:show]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :users
  resources :avatars
  resources :rooms do
    post 'add_event' => 'calendars#add_event'
    resources :powers
    resources :messages
    resources :reservations do
      resources :swap_reservations
    end
  end


  resources :conversations do
    resource :directs
  end


  #SE NON CI SONO ALTRE ROUTES, SIGNIFICA CHE L'ELEMENTO NON ESISTE ->
  match '*path' => 'application#render_404', via: :all
end
