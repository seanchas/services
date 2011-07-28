module Infosell
  
  class ServiceDescription < Infosell::Model::Base
    
    def self.for(service, user_id = '')
      cache(service.id, user_id) do
        new(xmlrpc_with_session("getServiceDescription", service.id, user_id)).tap(&:persist!)
      end
    end
    
    def desc=(value)
      self.short = value
    end
    
    def ext_desc=(value)
      self.full = value
    end
    
  end
  
end
