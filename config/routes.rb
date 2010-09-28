ActionController::Routing::Routes.draw do |map|
  
  map.filter :locale
  
  map.root :controller => :welcome
  
  map.resources :services, :only => [:index, :show]
  
end
