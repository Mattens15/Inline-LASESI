Rails.application.routes.draw do
  # gestione sessione omniauth e user normale
  get '/auth/:provider/callback', :to =>'sessions#create'
  get '/auth/failure', :to =>  redirect('/')# 'sessions_omniauth#failure'
  post 'rate' => 'rater#create'
  default_url_options :host => "localhost"
  root                     'mapbox#show'
  get 'dashboard'				=> 'mapbox#show'
  
  get 'signup'  => 'users#new'
  delete 'destroy' => 'users#destroy'
  get 'login'   => 'sessions#new'
  post'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy'
  get 'redirect', to: 'calendars#redirect'
  get 'callback', to: 'calendars#callback'
  put 'destroy_avatar' => 'rooms#destroy_avatar'
  
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :account_activations, only: [:edit]
  resources :users do
    get 'achievements' => 'users#achievements'
    member do
      put "like" => "users#upvote"
    end
  end
  
  resources :avatars
  
  resources :rooms do
    post 'add_event' => 'calendars#add_event'
    resources :powers
    resources :messages do
      post 'pin'=>'messages#pin'
    end
    resources :reservations do
      resources :swap_reservations
    end
  end


  resources :conversations do
    resource :directs
  end


  #SE NON CI SONO ALTRE ROUTES, SIGNIFICA CHE L'ELEMENTO NON ESISTE ->
  match '/change'=>'application#change_availability', via: :all
  match '*path' => 'application#render_404', via: :all
end
