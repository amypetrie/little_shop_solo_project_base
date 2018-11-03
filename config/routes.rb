Rails.application.routes.draw do
  root 'welcome#show'

  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  get '/logout', to: 'session#destroy'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/profile', to: 'users#show'
  namespace :profile do
    get 'edit'
    get 'orders'
  end

  get '/dashboard', to: 'dashboard#show'

  namespace :dashboard do
    resources :orders, only: [:index]
    resources :items, only: [:index]
  end

  resources :orders, only: [:index, :show, :create] do
    patch ':order_item_id/fulfill', to: 'order_items#update', as: 'item_fulfill'
  end
  resources :order_items, only: [:update]

  resources :items, only: [:index, :show]
  resources :users, only: [:index, :new, :create, :edit, :show, :update] do
    resources :orders, only: [:index, :update]
    patch 'enable', to: 'users#update'
    patch 'disable', to: 'users#update'
  end

  resources :merchants, only: [:index, :update, :show] do
    resources :orders, only: [:index]
    resources :items, only: [:index, :new, :edit, :create, :update] do
      patch 'enable', to: 'items#update'
      patch 'disable', to: 'items#update'
    end
  end

  resources :carts, path: '/cart', only: [:index] #dont want plural version of carts be resources
  delete '/cart', to: 'carts#empty'
  delete '/cart/:item_id', to: 'carts#remove'
  patch '/cart/:item_id', to: 'carts#update', as: 'cart_item_quantity'

  # custom error pages
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
end

# PRACTICE WITH LUKE

#   resources :users do
#     resources :items
#   end
#
#   resources :networks, only: [] do
#     resources :users, only: [:show]
#   end
#
#   scope module: :admin do
#     resources :items, only: [:index]
#     resources :networks
#     resources :users, only: [:show, :index, :destroy]
#   end

##scope means want to place controller in admin folder but not have the '/admin' in front of route
#CREATES
# scope module: 'admin' do
#   resources :articles, :comments
# end

# resources :articles, module: 'admin' --> for a single resource

#ROUTE WITHOUT PREFIX, NOT NESTED IN CONTROLLER
# scope '/admin' do
#   resources :articles, :comments
# end
