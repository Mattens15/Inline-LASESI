Rails.application.routes.draw do
# gestione sessione omniauth e user normale

 
  
  get '/auth/:provider/callback', :to =>'sessions#create'
  get '/auth/failure', :to =>  redirect('/')# 'sessions_omniauth#failure'
  post '/rate' => 'rater#create', :as => 'rate'
  default_url_options :host => "localhost"
  root                     'mapbox#show'
  get 'dashboard'				=> 'mapbox#show'
  get 'sessions/new'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'signup'  => 'users#new'
  delete 'destroy' => 'users#destroy'
  get 'login'   => 'sessions#new'
  post'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy'
  
  get '/redirect', to: 'calendars#redirect', as: 'redirect'
  get '/callback', to: 'calendars#callback', as: 'callback'
  put 'destroy_avatar' => 'rooms#destroy_avatar'

  resources :sessions, only: [:create, :destroy]
  resource :home, only: [:show]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :account_activations, only: [:edit]
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
  
  #SE NON CI SONO ALTRE ROUTES, SIGNIFICA CHE L'ELEMENTO NON ESISTE ->
  match '*path' => 'application#render_404', via: :all
end
