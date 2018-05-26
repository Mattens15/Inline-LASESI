Rails.application.routes.draw do
  resources :rooms
  resources :has_powers
  resources :prenotaziones
	resources :users	
	get 'map'				=> 'mapbox#show'
  post 'map'      => 'mapbox#show'
end
	
