Rails.application.routes.draw do
# gestione sessione omniauth

  get 'sessions_omniauth/new'
  get 'sessions_omniauth/create'
  get 'sessions_omniauth/failure'
  get '/login_omniauth', :to =>'sessions_omniauth#new', :as => :login_omniauth
  get '/auth/:provider/callback', :to =>'sessions_omniauth#create'
  get '/auth/failure', :to => 'sessions_omniaut#failure'
  get '/logout_omniauth', :to => 'sessions_omniauth#destroy'
  delete '/logout_omniauth', :to => 'sessions_omniauth#destroy'
  get 'signup_omniauth', :to =>'users_omniauth#new'
  get 'signup_omniauth', :to =>'users_omniauth#create'


#fine gestione sessione omniauth


  post '/rate' => 'rater#create', :as => 'rate'
  default_url_options :host => "localhost"
  root             'users#index'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup'  => 'users#new'
  post 'signup' => 'users#create'
  delete 'destroy' => 'users#destroy'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get 'password_resets/new'
  get 'password_resets/edit'
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
