ActionController::Routing::Routes.draw do |map|
  
  map.filter :locale
  
  map.root :controller => :welcome
  
end
