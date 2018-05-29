Rails.application.routes.draw do
  resources :users
  resources :rooms
	resources :users	
	get 'map'				=> 'mapbox#show'
  post 'map'      => 'mapbox#show'
end
	
