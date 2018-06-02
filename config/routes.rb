Rails.application.routes.draw do
  
  resources :users
  resources :rooms
	root                     'mapbox#show'
  get 'dashboard'				=> 'mapbox#show'
end
	
