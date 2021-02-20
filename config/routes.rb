Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  resources :clientes, only: [:new, :create, :edit, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  root 'home#index'

  get 'signup', to: 'clientes#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get '/depositar', to: 'clientes#depositar'
  post '/depositar', to: 'clientes#depositar'
  put '/clientes/:id/transferir', to: 'clientes#transferir', as: 'transferir'
  get '/clientes/:id/transferir', to: 'clientes#transferir'
  post '/clientes/:id/transferir', to: 'clientes#transferir'
  put '/clientes/:id/sacar', to: 'clientes#sacar', as: 'sacar'
  get '/clientes/:id/sacar', to: 'clientes#sacar'
  post '/clientes/:id/sacar', to: 'clientes#sacar'
  post '/clientes/:id/extrato', to: 'clientes#extrato'
  get '/clientes/:id', to: 'clientes#show'
  patch '/clientes/:id', to: 'clientes#edit'
  get '/clientes', to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
