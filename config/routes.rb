Rails.application.routes.draw do
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
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
