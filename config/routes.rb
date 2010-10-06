ActionController::Routing::Routes.draw do |map|
  
  map.filter :locale
  
  map.root :controller => :welcome
  
  map.resources :services, :only => [:index, :show], :member => { :offer => :get, :prices => :get } do |service|
    service.resources :orders, :only => [:new, :create]
  end
  
  map.resource :requisite, :only => [:show, :create, :update]
  
  map.resources :orders, :only => [:index, :edit, :update], :collection => { :check => :post }
  
end
