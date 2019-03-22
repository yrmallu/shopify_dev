Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'

  get '/orders/:id' => 'home#get_order'

  get '/profit_details' => 'home#profit_details'

  post '/details' => 'home#update_order_details'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
