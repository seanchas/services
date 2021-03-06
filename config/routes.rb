ActionController::Routing::Routes.draw do |map|
  
  map.filter :locale
  
  map.root :controller => :welcome
  
  map.resources :services, :only => [:index, :show], :member => { :offer => :get, :prices => :get } do |service|
    service.resources :orders, :only => [:new, :create]
  end
  
  map.resource :requisite, :only => [:show, :create, :update]
  
  map.resources :orders, :only => [:index, :edit, :update], :collection => { :destroy_many => :delete }
  
  map.namespace :admin do |admin|
    admin.root      :controller => :welcome
    admin.resources :infosell_resources
    admin.resources :infosell_resources_relations
    admin.resources :users
  end
  
  map.xmlrpc "admin/xml-rpc", :controller => :welcome, :action => :xmlrpc

end
