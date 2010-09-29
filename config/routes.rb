ActionController::Routing::Routes.draw do |map|
  
  map.filter :locale
  
  map.root :controller => :welcome
  
  map.resources :services, :only => [:index, :show], :member => { :offer => :get, :prices => :get }
  
  map.resources :requisites
  
end
