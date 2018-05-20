Rails.application.routes.draw do
	resources :users
	
	get 'map'					=> 'mapbox#show'
  get 'signup'			=> 'users#new'
end
	
