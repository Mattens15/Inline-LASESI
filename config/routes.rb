Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup'  => 'users#new'
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
