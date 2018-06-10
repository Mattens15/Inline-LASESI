Rails.application.routes.draw do
  
  resources :swap_reservations
  get 'powers/create'
  get 'powers/destroy'
  get 'reservation/create'
  get 'reservation/update'
  get 'reservation/destroy'
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
  scope :ujs, defaults: {format: :ujs} do
    patch 'room_index_reservation' => 'rooms#index_reservation'
  end
  resources :rooms
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :reservations

end
	
