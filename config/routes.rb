Rails.application.routes.draw do
  
  resources :rooms
	root                     'mapbox#show'
  get 'dashboard'				=> 'mapbox#show'
end
	
