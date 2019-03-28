Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'

  resources :orders
  get '/profit_details' => 'orders#profit_details'

  resources :customers, only: [:index]

  resources :products, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

