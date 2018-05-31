Rails.application.routes.draw do
  
  resources :users
  resources :rooms
	root                     'mapbox#show'
  get 'dashboard'				=> 'mapbox#show'
  get 'redirect'        => 'event#redirect'
  get 'callback'        => 'event#callback'
  get 'calendars'       => 'event#calendars'
  get 'events/:calendar_id', to: 'event#events', as: 'events', calendar_id: /[^\/]+/
  post 'events/:calendar_id', to: 'event#new_event', as: 'new_event', calendar_id: /[^\/]+/
end
	
