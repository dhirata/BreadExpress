BreadExpress::Application.routes.draw do

  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :order_items, only: [:create, :update, :destroy]
  resources :sessions
  resources :users
  resource :cart, only: [:show]
  #Oops accidentally made it cart (singular)
  resources :item_prices
  
  # Authentication routes
  get 'user/edit' => 'users#edit', as: :edit_current_user
  get 'signup' => 'customers#new', as: :signup
  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login


  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'search' => 'home#search', as: :search
  get 'cylon' => 'errors#cylon', as: :cylon
  
  # Set the root url
  root :to => 'home#home'  
  
  # Named routes
  get 'admin_home' => 'home#admin_home', as: :admin_home
  get 'customer_home' => 'home#customer_home', as: :customer_home
  get 'baker_home' => 'home#baker_home', as: :baker_home
  get 'shipper_home' => 'home#shipper_home', as: :shipper_home
  get 'checkout' => 'orders#checkout', as: :checkout



  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
