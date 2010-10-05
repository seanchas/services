ActionController::Routing::Routes.draw do |map|
  
  map.filter :locale
  
  map.root :controller => :welcome
  
  map.resources :services, :only => [:index, :show], :member => { :offer => :get, :prices => :get }
  
  map.resource :requisite, :only => [:show, :create, :update]
  
  map.resources :orders, :collection => { :check => :post }
  
end
