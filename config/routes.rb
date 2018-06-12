Rails.application.routes.draw do
<<<<<<< HEAD
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#signup'
  post '/signup',  to: 'users#create'
  resources :users
end
=======
  get 'home/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get 'auth/:provider/callback' => 'sessions#callback' #facebook routing

end

GoogleAuthExample::Application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  resource :home, only: [:show]

  root to: "home#show"
end
>>>>>>> d9e106925122d18f3578b170d0e2516e04ff563a
