module Infosell
  class Service
    
    class Description < Base
      
      def self.for(service)
        cache(service.id) do
          new(xmlrpc_with_session("getServiceDescription", service.id)).tap(&:persist!)
        end
      end
      
    end
    
  end
end
